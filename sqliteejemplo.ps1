# Grab the SQLite3 DLL here:
#    https://system.data.sqlite.org/index.html/doc/trunk/www/downloads.wiki
#
# PowerShell SQLite DB example.
# C. Nichols <mohawke@gmail.com>, Aug. 2019
# Make sure to change DLL, database, and log file paths.
  
Add-Type -Path "c:\sqlite_tests\System.Data.SQLite.dll" # Change path
  
Function createDataBase([string]$db) {
    Try {
        If (!(Test-Path $db)) {
        
            $CONN = New-Object -TypeName System.Data.SQLite.SQLiteConnection
  
            $CONN.ConnectionString = "Data Source=$db"
            $CONN.Open()
  
            # TEXT as ISO8601 strings ('YYYY-MM-DD HH:MM:SS.SSS')
            # ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, INSERT NULL to increment.
            $createTableQuery = "CREATE TABLE printer_usage (
                                        ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                                        printed_dt        TEXT    NULL,
                                        printed_tm        TEXT    NULL,
                                        printed_doc_nm    TEXT    NULL,
                                        printed_doc_sz    INTEGER NULL,
                                        printed_page_cnt  INTEGER NULL,
                                        print_user_id     TEXT    NULL,
                                        print_user_comp   TEXT    NULL,
                                        print_serv_nm     TEXT    NULL,
                                        printer_nm        TEXT    NULL
                                        );"
            $createUniqueIndex = "CREATE UNIQUE INDEX print_idx ON printer_usage(printed_dt, printed_tm, print_user_id, printed_doc_nm);"
  
  
            $CMD = $CONN.CreateCommand()
            $CMD.CommandText = $createTableQuery
            $CMD.ExecuteNonQuery()
            $CMD.CommandText = $createUniqueIndex
            $CMD.ExecuteNonQuery()
  
            $CMD.Dispose()
            $CONN.Close()
            Log-It "Create database and table: Ok"
  
        } Else {
            Log-It "DB Exists: Ok"
        }
  
    } Catch {
        Log-It "Could not create database: Error"
    }
}
  
Function queryDatabase([string]$db, [string]$sql) {
  
    Try {
        If (Test-Path $db) {
  
            $CONN = New-Object -TypeName System.Data.SQLite.SQLiteConnection
            $CONN.ConnectionString = "Data Source=$db"
            $CONN.Open()
  
            $CMD = $CONN.CreateCommand()
            $CMD.CommandText = $sql
  
            $ADAPTER = New-Object  -TypeName System.Data.SQLite.SQLiteDataAdapter $CMD
            $DATA = New-Object System.Data.DataSet
  
            $ADAPTER.Fill($DATA)
  
            $TABLE = $DATA.Tables
  
            ForEach ($t in $TABLE){
                Write-Output $t
            }
  
            $CMD.Dispose()
            $CONN.Close()
  
        } Else {
            Log-It "Unable to find database: Query Failed"
        }
  
    } Catch {
        Log-It "Unable to query database: Error"
    }
}
  
Function insertDatabase([string]$db, [System.Collections.ArrayList]$rows) {
  
    Try {
        If (Test-Path $db) {
        
            $CONN = New-Object -TypeName System.Data.SQLite.SQLiteConnection
  
            $CONN.ConnectionString = "Data Source=$db"
            $CONN.Open()
  
            $CMD = $CONN.CreateCommand()
            #$Counter = 0
            ForEach($row in $rows) {
        
                $sql = "INSERT OR REPLACE INTO printer_usage (ID,printed_dt,printed_tm,printed_doc_nm,printed_doc_sz,printed_page_cnt,print_user_id,print_user_comp,print_serv_nm,printer_nm)"
                $sql += " VALUES (@ID,@printed_dt,@printed_tm,@printed_doc_nm,@printed_doc_sz,@printed_page_cnt,@print_user_id,@print_user_comp,@print_serv_nm,@printer_nm);"
                 
                $CMD.Parameters.AddWithValue("@ID", $NULL)
                $CMD.Parameters.AddWithValue("@printed_dt", $row.printed_dt)
                $CMD.Parameters.AddWithValue("@printed_tm", $row.printed_tm)
                $CMD.Parameters.AddWithValue("@printed_doc_nm", $row.printed_doc_nm)
                $CMD.Parameters.AddWithValue("@printed_doc_sz", $row.printed_doc_sz)
                $CMD.Parameters.AddWithValue("@printed_page_cnt", $row.printed_page_cnt)
                $CMD.Parameters.AddWithValue("@print_user_id", $row.print_user_id)
                $CMD.Parameters.AddWithValue("@print_user_comp", $row.print_user_comp)
                $CMD.Parameters.AddWithValue("@print_serv_nm", $row.print_serv_nm)
                $CMD.Parameters.AddWithValue("@printer_nm", $row.printer_nm)
  
                Write-Output $sql
  
                $CMD.CommandText = $sql
                $CMD.ExecuteNonQuery()
                #$Counter += 1
            }
  
            $CMD.Dispose()
            $CONN.Close()
  
            Log-It "Inserted records successfully: Ok"
  
        } Else {
            Log-It "Unable to find database: Insert Failed"
        }
  
    } Catch {
        Log-It "Unable to insert into database: Error"
    }
}
  
Function Log-It([string]$logLine)
{
    $LogPath = "c:\sqlite_tests\sqlite.log" # Change path
    $NewLine = "`r`n"
  
    $Line = "{0}{1}" -f $logLine, $NewLine
    if ($logPath) {
        write-output $Line
        $Line | Out-File $logPath -Append
    } else {
        write-output $Line
    }
}
  
# ******** MAIN ********
  
$DBPath = "c:\sqlite_tests\print_events.sqlite" # Change path
$Rows = New-Object System.Collections.ArrayList
  
$CDate = Get-Date -format "yyyy-MM-dd"
$CTime = Get-Date -format "HH:mm:ss"
  
# Fake Records
$Rows.Add(@{'printed_dt'=$CDate; 'printed_tm'= $CTime; 'printed_doc_nm'='test.txt'; 'printed_doc_sz'=10; 'printed_page_cnt'=10; 'print_user_id'='nich12'; 'print_user_comp'='m123'; 'print_serv_nm'='printA'; 'printer_nm'='l52'})
$Rows.Add(@{'printed_dt'=$CDate; 'printed_tm'= $CTime; 'printed_doc_nm'='test.doc'; 'printed_doc_sz'=20; 'printed_page_cnt'=12; 'print_user_id'='ward32'; 'print_user_comp'='m234'; 'print_serv_nm'='printA'; 'printer_nm'='l67'})
$Rows.Add(@{'printed_dt'=$CDate; 'printed_tm'= $CTime; 'printed_doc_nm'='test.ps1'; 'printed_doc_sz'=30; 'printed_page_cnt'=14; 'print_user_id'='jame67'; 'print_user_comp'='m345'; 'print_serv_nm'='printB'; 'printer_nm'='l87'})
  
$Query = "Select * From printer_usage"
  
# Create Db and Table.
createDataBase $DBPath
  
# Insert records.
insertDatabase $DBPath $Rows
  
# Fetch records.
queryDatabase $DBPath $Query