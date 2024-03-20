codeunit 70002 "SendOrderConfirmation"
{
    procedure SendOrderConfirmation(orderNo: Text): Boolean

    var
        ExitValue: Boolean;

        SalesHeaderRec: Record "Sales Header";
        SellToEmail: Text;
        SellToCustomer: Text;
        SalespersonCode: Text;
        ExternalDocNo: Text;
        OrderValue: Text;

        SalespersonRec: Record "Salesperson/Purchaser";
        SalespersonEmailList: Text;
        Recipients: Text;
        CcList: Text;

        DateTodayXml: Text;
        DateTodayText: Text;
        XmlParameters: Text;
        Format: ReportFormat;

        tmpBlob: Codeunit "Temp Blob";
        cnv64: Codeunit "Base64 Convert";
        InStr: Instream;
        OutStr: OutStream;
        txtB64: Text;
        Email: Codeunit Email;
        emailMsg: Codeunit "Email Message";
        EmailBody: Text;

    begin
        ExitValue := false;

        SalesHeaderRec.Reset;
        SalesHeaderRec.SetRange("No.", orderNo);
        SalesHeaderRec.FindFirst;
        SellToEmail := SalesHeaderRec."Sell-to E-Mail";
        SellToCustomer := SalesHeaderRec."Sell-to Customer Name";
        SalespersonCode := SalesHeaderRec."Salesperson Code";
        if (SalesHeaderRec."External Document No." = '') then ExternalDocNo := '-' else ExternalDocNo := SalesHeaderRec."External Document No.";
        SalesHeaderRec.CalcFields(Amount);
        OrderValue := Format(SalesHeaderRec.Amount, 0, '<Precision,2:2><Standard Format,0>');

        SalespersonRec.Reset;
        SalespersonRec.SetRange("Code", SalespersonCode);
        SalespersonRec.FindFirst;
        SalespersonEmailList := SalespersonRec.c006_Email_List;
        if ((SellToEmail = '') and (SalespersonEmailList = '')) then exit(ExitValue);
        if (SellToEmail = '') then begin
            Recipients := SalespersonEmailList;
            CcList := '';
        end else begin
            Recipients := SellToEmail;
            CcList := SalespersonEmailList;
        end;

        DateTodayXml := Format(System.Today(), 10, '<Year4>-<Month,2>-<Day,2>');
        DateTodayText := Format(System.Today(), 10, '<Month,2>/<Day,2>/<Year4>');
        XmlParameters := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Standard Sales - Order Conf." id="1305"><Options><Field name="LogInteraction">true</Field><Field name="DisplayAssemblyInformation">true</Field><Field name="ArchiveDocument">false</Field></Options><DataItems><DataItem name="Header">VERSION(1) SORTING(Field1,Field3) WHERE(Field3=1(' + orderNo + '))</DataItem><DataItem name="Line">VERSION(1) SORTING(Field3,Field4)</DataItem><DataItem name="AssemblyLine">VERSION(1) SORTING(Field2,Field3)</DataItem><DataItem name="WorkDescriptionLines">VERSION(1) SORTING(Field1)</DataItem><DataItem name="VATAmountLine">VERSION(1) SORTING(Field5,Field9,Field10,Field13,Field16)</DataItem><DataItem name="VATClauseLine">VERSION(1) SORTING(Field5,Field9,Field10,Field13,Field16)</DataItem><DataItem name="ReportTotalsLine">VERSION(1) SORTING(Field1)</DataItem><DataItem name="USReportTotalsLine">VERSION(1) SORTING(Field1)</DataItem><DataItem name="LetterText">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Totals">VERSION(1) SORTING(Field1)</DataItem></DataItems></ReportParameters>';
        tmpBlob.CreateOutStream(OutStr);

        if Report.SaveAs(1305, XmlParameters, Format::Pdf, OutStr) then begin
            tmpBlob.CreateInStream(InStr);
            txtB64 := cnv64.ToBase64(InStr, true);
            EmailBody := '<!doctype html><html><style>.po-number {overflow-wrap: break-word;word-wrap: break-word;max-width: 200px; /* Set your desired maximum width */}tbod</style><table width="800" border="0" align="center" cellpadding="0" cellspacing="0"><tbody><tr><td height="100" align="right"><img src="https://go.micromeritics.com/l/954393/2023-11-10/5wgnb/954393/1699637935bbNiDa2Q/MicroLOGO_HORIZONTAL.png" width="250"/></td></tr><tr><td><p style="font-family:Arial,Helvetica,sans-serif; font-size:20px">Order Confirmation</p><p style="font-family:Arial,Helvetica,sans-serif; font-size:14px">Thank you for your business. Your order confirmation is attached to this message.</p></td></tr><tr><td align="left"><table width="800" cellpadding="10" cellspacing="0"style="font-family:Arial,Helvetica,sans-serif; font-size:16px"><thead><tr><th style="border-bottom: 1px solid #000" height="50px" width="100px" align="left">Order No.</th><th style="border-bottom: 1px solid #000" height="50px" width="200px" align="left">PO Number</th><th style="border-bottom: 1px solid #000" height="50px" width="300px" align="left">Customer</th><th style="border-bottom: 1px solid #000" height="50px" width="200px" align="right">Total USD (Pre-Tax)</th></tr></thead><tbody><tr style="height: 50px"><td>' + orderNo + '</td><td class="po-number">' + ExternalDocNo + '</td><td>' + SellToCustomer + '</td><td align="right">' + OrderValue + '</td></tr></tbody></table></td></tr></tbody></table></html>';
            emailMsg.Create(
                Recipients,
                'MIC Order Confirmation ' + orderNo,
                EmailBody,
                true
            );
            emailMsg.SetRecipients(enum::"Email Recipient Type"::Cc, CcList);
            emailMsg.AddAttachment('MIC Order Confirmation ' + orderNo + '.pdf', 'PDF', txtB64);
            Email.Send(emailMsg);
        end;
        ExitValue := true;
        exit(ExitValue);
    end;
}