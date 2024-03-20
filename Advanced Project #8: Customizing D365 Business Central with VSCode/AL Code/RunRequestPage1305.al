codeunit 70003 "RunRequestPage1305"
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    var
        Parameters: Text;
    begin
        Parameters := Report.RunRequestPage(1305);
        Message(Parameters);
    end;
}