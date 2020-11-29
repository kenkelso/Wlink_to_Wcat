unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, Crt;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label10: TLabel;
    xRain: TComboBox;
    Label8: TLabel;
    Label9: TLabel;
    xBar: TComboBox;
    xDate: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    xWdir: TComboBox;
    xTemp: TComboBox;
    xWind: TComboBox;
    SampleTime15: TCheckBox;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    OpenDialog1: TOpenDialog;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ddmmyyClick(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure mmddyyClick(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
    WLFileName, WCFileName: string;
    tfIn: textfile;
  end;

var
  Form1: TForm1;
procedure MakeCSV(S1: string);
implementation

{$R *.lfm}




{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);

var
  tfOut, M1, M2, M3, M4, M5, M6, M7, M8, M9, M10, M11, M12: TextFile;
  sIn, sOut, t1, t2, t3, t4, P, Py, Pm, CurrentDay, CurrentMonth, CurrentYear, Min, sTemp, Verify: string;
  S : TStringList;
  i, TimeInt : integer;
  DailyRain, MonthlyRain, YearlyRain: real;
begin
   try
  if WLFileName = '' then
     begin
       showmessage('No input file selected');
       exit;
     end;
    if WCFileName = '' then
     begin
       showmessage('No OutPut Directory selected');
       exit;
     end;
  S := TStringList.Create;
  // Set the name of the file that will be created

  AssignFile(M1, WCFileName + '/1_WeatherCatData.cat');
  rewrite(M1);
  AssignFile(M2, WCFileName + '/2_WeatherCatData.cat');
  rewrite(M2);
  AssignFile(M3, WCFileName + '/3_WeatherCatData.cat');
  rewrite(M3);
  AssignFile(M4, WCFileName + '/4_WeatherCatData.cat');
  rewrite(M4);
  AssignFile(M5, WCFileName + '/5_WeatherCatData.cat');
  rewrite(M5);
  AssignFile(M6, WCFileName + '/6_WeatherCatData.cat');
  rewrite(M6);
  AssignFile(M7, WCFileName + '/7_WeatherCatData.cat');
  rewrite(M7);
  AssignFile(M8, WCFileName + '/8_WeatherCatData.cat');
  rewrite(M8);
  AssignFile(M9, WCFileName + '/9_WeatherCatData.cat');
  rewrite(M9);
  AssignFile(M10, WCFileName + '/10_WeatherCatData.cat');
  rewrite(M10);
  AssignFile(M11, WCFileName + '/11_WeatherCatData.cat');
  rewrite(M11);
  AssignFile(M12, WCFileName + '/12_WeatherCatData.cat');
  rewrite(M12);

  writeln(M1, Edit1.Text);
  writeln(M2, Edit1.Text);
  writeln(M3, Edit1.Text);
  writeln(M4, Edit1.Text);
  writeln(M5, Edit1.Text);
  writeln(M6, Edit1.Text);
  writeln(M7, Edit1.Text);
  writeln(M8, Edit1.Text);
  writeln(M9, Edit1.Text);
  writeln(M10, Edit1.Text);
  writeln(M11, Edit1.Text);
  writeln(M12, Edit1.Text);


  AssignFile(tfIn, WLFileName);
//  ShowMessage(WCFileName + '/12_WeatherCatData.cat');

  // Use exceptions to catch errors (this is the default so not absolutely requried)
  {$I+}

  // Embed the file creation in a try/except block to handle errors gracefully
  try
    // Create the WeatherCAT file.
    reset(tfIn);   //Open input file
    i := -1;
    CurrentDay := '';
    CurrentYear := '';
    CurrentMonth := '';
    DailyRain := 0.00;
    YearlyRain := 0.00;
    MonthlyRain := 0.00;
    //disregard first 2 lines as they are just headers
    readln(tfIn, sIn);
    readln(tfIn, sIn);
    while not eof(tfIn) do
          begin
             sIn := '';
             i := i + 1;
             readln(tfIn, sIn);
             //parse space delimited file
             // first take out the space in 12 hour time.
             if Pos('p', sIn) > 0 then
                begin
                     sTemp := LeftStr(sIn, pos('p', sIn) - 2) + RightStr(sIn, Length(sIn) - pos('p', sIn) + 1);
                     sIn := sTemp;
                end;
             if pos('a', sIn) > 0 then
                begin
                     sTemp := LeftStr(sIn, pos('a', sIn) - 2) + RightStr(sIn, Length(sIn) - pos('a', sIn) + 1);
                     sIn := sTemp;
                end;

           //  showmessage(sIn);
             S.Delimiter:=' ';
             S.DelimitedText:=sIn;
             //deal with date and time
             t2 := '';
             t1 := S[0];  //put string in a stringlist
          //   showmessage(t1);
             if (t1[1] <> '-') and (S[2] <> '---') then
                begin
                     if CurrentYear = '' then CurrentYear := t1[7] + t1[8];
                     if CurrentYear <> t1[7] + t1[8] then exit;
                     if xDate.Text = 'MM/DD/YY' then t2 := t1[4] + t1[5]
                     else t2 := t1[1] + t1[2];
                     //calculate daily and monthly rain
                     //showmessage(t2);
                     if CurrentDay <> t2 then
                     begin
                          CurrentDay := t2;
                          DailyRain := 0.00;
                     end;
                     DailyRain := DailyRain + strToFloat(S[16]);
                     //showmessage('DailyRain='+S[16]);
                     //Convert DailyRain to mm if reqd.
                     if xRain.Text = 'Inch' then P := floatToStrF(DailyRain * 25.4, ffFixed , 4, 2)
                        else P := floatToStrF(DailyRain, ffFixed , 4, 2);

                     t3 := S[0];
                     //showmessage(t3);
                     if xDate.Text = 'MM/DD/YY' then t4 := t3[1] + t3[2]
                     else t4 := t3[4] + t3[5];
                 //    showmessage('CurrentMonth='+t4);
                     if CurrentMonth <> t4 then
                        begin
                             CurrentMonth := t4;
                             MonthlyRain := 0.00;
                             i := 0;
                         end;
                  MonthlyRain := MonthlyRain + strToFloat(S[16]);
                  //Convert MonthlyRain to mm if Reqd.
                  if xRain.Text = 'Inch' then Pm := floatToStrF(MonthlyRain * 25.4, ffFixed ,4, 2)
                     else Pm := floatToStrF(MonthlyRain, ffFixed ,4, 2);
                  //showmessage('PM='+Pm);
                  YearlyRain := YearlyRain + strToFloat(S[16]);
                  //Convert YealyRain to mm if Reqd.
                  if xRain.Text = 'Inch' then Py := floatToStrF(YearlyRain * 25.4, ffFixed, 4, 2)
                     else Py := floatToStrF(YearlyRain, ffFixed, 4, 2);
                  t1 := S[1];      //Get Time
                  // if 12 hour convert to 24 hour
                  if (pos('a', t1) > 0) then
                     begin
                          if length(t1) = 6 then t1 := LeftStr(t1, 5)
                             else t1 := LeftStr(t1, 4);
                          if LeftStr(t1, 2) = '12' then t1 := '0' + RightStr(t1 ,3);
                       //   showmessage(' am to 24 = ' + t1);
                     end;
                  if pos('p', t1) > 0 then
                     begin
                          if length(t1) = 6 then t1 := LeftStr(t1, 5)
                             else t1 := LeftStr(t1, 4);
                          if LeftStr(t1, 2) = '12' then t1 := '0' + RightStr(t1 ,3);
                          TimeInt := StrToInt(LeftStr(t1, Pos(':', t1) - 1));
                          TimeInt := TimeInt + 12;
                          t1 := IntToStr(TimeInt) + RightStr(t1, 3);
                      //    showmessage(' pm to 24 = ' + t1);
                     end;
                  // pad time if necessary
                  if length(t1) = 4 then t1 := '0' + t1;
                  t2 := t2 + t1[1] + t1[2] +t1[4] + t1[5];

                  //showmessage('Day:' + CurrentDay + ' Rain:' + P);
                  Min := t1[4] + t1[5];
                  //showmessage(t1 +'     ' + Min);

                  //Do convertion to Metric units
                  if xTemp.Text = 'F' then
                       begin
                          S[2] := FloatToStrf((StrToFloat(S[2]) - 32) / 1.8, ffFixed,3,2);    //Temp Out
                          S[20] := FloatToStrf((StrToFloat(S[20]) - 32) / 1.8, ffFixed,3,2);  //Temp In
                          S[6] := FloatToStrf((StrToFloat(S[6]) - 32) / 1.8, ffFixed,3,2);    //Dew Point
                          S[12] := FloatToStrf((StrToFloat(S[12]) - 32) / 1.8, ffFixed,3,2);  //Wind Chill
                       end;
                   if xBar.Text = 'inHg' then S[15] := FloatToStrf(StrToFloat(S[15]) * 33.86, ffFixed,4,2);
                    //    mBar: Do Nothing;
                    //    hPa:  Do Nothing;
                   case xWind.Text of
                       'MPH': begin
                                     S[7] := FloatToStrf((StrToFloat(S[7]) * 1.609344 ), ffFixed,3,2);   //Wind Speed
                                     S[10] := FloatToStrf((StrToFloat(S[10]) * 1.609344 ), ffFixed,3,2);  //Wind Gust
                              end;
                       'Knots': begin
                                     S[7] := FloatToStrf((StrToFloat(S[7]) * 1.85199 ), ffFixed,3,2);  //Wind Speed
                                     S[10] := FloatToStrf((StrToFloat(S[10]) * 1.85199 ), ffFixed,3,2); //Wind Gust
                                end;
                       'm/sec': begin
                                     S[7] := FloatToStrf((StrToFloat(S[7]) * 3.6 ), ffFixed,3,2);   //Wind Speed
                                     S[10] := FloatToStrf((StrToFloat(S[10]) * 3.6 ), ffFixed,3,2);  //Wind Gust
                                end;
                       // Km/Hr:  Do nothing;
                   end;
                   if (xWdir.Text = 'Compass') or (xWdir.Text = 'Cardinal') then
                       case S[8] of
                            'N': S[8] := '0';
                            'NNE': S[8] := '22';
                            'NE': S[8] := '45';
                            'ENE': S[8] := '67';
                            'E': S[8] := '90';
                            'ESE': S[8] := '112';
                            'SE': S[8] := '135';
                            'SSE': S[8] := '157';
                            'S': S[8] := '180';
                            'SSW': S[8] := '202';
                            'SW': S[8] := '225';
                            'WSW': S[8] := '247';
                            'W': S[8] := '270';
                            'WNW': S[8] := '292';
                            'NW': S[8] := '315';
                            'NNW': S[8] := '337';
                       end;
                       //'Degrees': Do Nothing;

                  if SampleTime15.Checked then
                     begin
                          if (Min = '00') or (Min = '15') or (Min = '30') or (Min = '45') then
                             begin
                                  sOut := intToStr(i) + ' t:' + t2;
                                  sOut := sOut + ' T:' + S[2];
                                  sOut := sOut + ' Ti:' + S[20];
                                  sOut := sOut + ' D:' + S[6];
                                  sOut := sOut + ' Pr:' + S[15];
                                  sOut := sOut + ' W:' + S[7];
                                  sOut := sOut + ' Wd:' + S[8];
                                  sOut := sOut + ' Wc:' + S[12];
                                  sOut := sOut + ' Wg:' + S[10];
                                  sOut := sOut + ' Ph:0.00';
                                  sOut := sOut + ' P:' + P;
                                  sOut := sOut + ' H:' + S[5];
                                  sOut := sOut + ' Hi:' + S[21];
                                  sOut := sOut + ' U:0.0';
                                  sOut := sOut + ' Lw4:0.0';
                                  sOut := sOut + ' Pm:' + Pm;
                                  sOut := sOut + ' Py:' + Py;
                                  sOut := sOut + ' Ed:0.0';
                                  sOut := sOut + ' Em:0.0';
                                  sOut := sOut + ' Ey:0.0';
                                  sOut := sOut + ' C:"N/A"';
                                  sOut := sOut + ' V:4';
                                  t1 := S[0];
                                  if t4 = '01' then writeln(M1, sOut);
                                  if t4 = '02' then writeln(M2, sOut);
                                  if t4 = '03' then writeln(M3, sOut);
                                  if t4 = '04' then writeln(M4, sOut);
                                  if t4 = '05' then writeln(M5, sOut);
                                  if t4 = '06' then writeln(M6, sOut);
                                  if t4 = '07' then writeln(M7, sOut);
                                  if t4 = '08' then writeln(M8, sOut);
                                  if t4 = '09' then writeln(M9, sOut);
                                  if t4 = '10' then writeln(M10, sOut);
                                  if t4 = '11' then writeln(M11, sOut);
                                  if t4 = '12' then writeln(M12, sOut);
                             end;
                          end
                          else
                              begin
                              sOut := intToStr(i) + ' t:' + t2;
                              sOut := sOut + ' T:' + S[2];
                              sOut := sOut + ' Ti:' + S[20];
                              sOut := sOut + ' D:' + S[6];
                              sOut := sOut + ' Pr:' + S[15];
                              sOut := sOut + ' W:' + S[7];
                              sOut := sOut + ' Wd:' + S[8];
                              sOut := sOut + ' Wc:' + S[12];
                              sOut := sOut + ' Wg:' + S[10];
                              sOut := sOut + ' Ph:0.00';
                              sOut := sOut + ' P:' + P;
                              sOut := sOut + ' H:' + S[5];
                              sOut := sOut + ' Hi:' + S[21];
                              sOut := sOut + ' U:0.0';
                              sOut := sOut + ' Lw4:0.0';
                              sOut := sOut + ' Pm:' + Pm;
                              sOut := sOut + ' Py:' + Py;
                              sOut := sOut + ' Ed:0.0';
                              sOut := sOut + ' Em:0.0';
                              sOut := sOut + ' Ey:0.0';
                              sOut := sOut + ' C:"N/A"';
                              sOut := sOut + ' V:4';
                              t1 := S[0];
                              if t4 = '01' then writeln(M1, sOut);
                              if t4 = '02' then writeln(M2, sOut);
                              if t4 = '03' then writeln(M3, sOut);
                              if t4 = '04' then writeln(M4, sOut);
                              if t4 = '05' then writeln(M5, sOut);
                              if t4 = '06' then writeln(M6, sOut);
                              if t4 = '07' then writeln(M7, sOut);
                              if t4 = '08' then writeln(M8, sOut);
                              if t4 = '09' then writeln(M9, sOut);
                              if t4 = '10' then writeln(M10, sOut);
                              if t4 = '11' then writeln(M11, sOut);
                              if t4 = '12' then writeln(M12, sOut);
                          end;
                     end;
          end;

finally
  CloseFile(tfIn);
  CloseFile(M1);
  CloseFile(M2);
  CloseFile(M3);
  CloseFile(M4);
  CloseFile(M5);
  CloseFile(M6);
  CloseFile(M7);
  CloseFile(M8);
  CloseFile(M9);
  CloseFile(M10);
  CloseFile(M11);
  CloseFile(M12);
  // Give feedback and wait for key press
  showmessage('Done');
end;

  except
    // If there was an error the reason can be found here
    on E: EInOutError do
      showmessage('File handling error occurred. Details: ' + E.ClassName + '/' + E.Message);
    on E: EStringListError do
      showmessage('Wrong Date Format in WeatherLink File: ' + E.ClassName + '/' + E.Message);
  end;
  S.Free;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   OpenDialog1.Execute;
   WLFileName := OpenDialog1.FileName;
   Label1.Caption:=WLFileName;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
   SelectDirectoryDialog1.Execute;
   WCFileName := SelectDirectoryDialog1.FileName;
   Label2.Caption:=WCFileName;
end;

procedure TForm1.ddmmyyClick(Sender: TObject);
begin

end;

procedure TForm1.Label3Click(Sender: TObject);
begin

end;

procedure TForm1.mmddyyClick(Sender: TObject);
begin

end;

procedure MakeCSV(S1: string);

begin

end;
end.

