# 計時器
function StopWatch {
    [CmdletBinding(DefaultParameterSetName = "C")]
    param (
        [Parameter(ParameterSetName = "A")]
        [Switch] $Start,
        [Parameter(ParameterSetName = "B")]
        [Switch] $Stop,
        [Parameter(ParameterSetName = "B")]
        [Switch] $Lap,
        [Parameter(ParameterSetName = "B")]
        [Switch] $Split,
        [Parameter(ParameterSetName = "B", ValueFromPipeline)]
        [Object] $StWh = $Null,
        [Parameter(Position = 0, ParameterSetName = "C")]
        [ScriptBlock] $ScriptBlock,
        [Parameter(ParameterSetName = "")]
        [String] $FormatType = "{0:hh\:mm\:ss\.fff}"
    )
    # 時間物件操作
    if ($Start) {
        $StWh = New-Object System.Diagnostics.Stopwatch
        $time = [timespan]::FromMilliseconds($StWh.ElapsedMilliseconds)
        $StWh.Start()
        $Script:__StopWatch_temp__ = $time
        return $StWh
    } elseif($Stop -or $Lap -or $Split) {
        $StWh.Stop()
        $time = [timespan]::FromMilliseconds($StWh.ElapsedMilliseconds)
        if ($Stop) { # 暫停計時:: 當前-該計時器暫停
            $result = $time
        } if ($Lap) { # 分圈計時:: 當前-該計時器初始
            $result = $time
            $StWh.Start()
        } elseif ($Split) { # 分段計時:: 當前-任意計時器的上一次的操作
            $result = $time.Add($Script:__StopWatch_temp__.Negate())
            $StWh.Start()
        } $Script:__StopWatch_temp__ = $time
        return ($FormatType -f $result)
    # 測試區塊內的時間
    } elseif ($ScriptBlock) {
        $StWh = New-Object System.Diagnostics.Stopwatch; $StWh.Start()
        if ($ScriptBlock.ToString().Trim() -ne '') { & $ScriptBlock }
        $StWh.Stop(); $time = [timespan]::FromMilliseconds($StWh.ElapsedMilliseconds)
        return ($FormatType -f $time)
    } else { return $Null }
}

# $StWh=(StopWatch -Start);
# sleep 1; ($StWh|StopWatch -Split);
# sleep 1; ($StWh|StopWatch -Lap);
# sleep 1; ($StWh|StopWatch -Stop);
# StopWatch {sleep 1}
