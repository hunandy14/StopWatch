PowerShell 計時器物件
===

## 快速使用
```ps1
irm biy.ly/chg_StopWatch|idx
StopWatch{
    sleep 1
}
```

## 詳細說明
```ps1
# 載入函式庫
irm biy.ly/chg_StopWatch|idx


# 建立計時器
$StWh=(StopWatch -Start)

# 分圈計時 (當前-開始)
($StWh|StopWatch -Lap)

# 分段計時 (當前-任意時器的上一次任意操作)
($StWh|StopWatch -Split)

# 停止計時
($StWh|StopWatch -Stop)

# 計時區塊內的時間
StopWatch -ScriptBlock:{
    sleep 1
}
```
