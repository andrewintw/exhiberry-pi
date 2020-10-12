# exhiberry-pi

A Toolkit for Exhibits "Move in"


## 目標

* 發展一個適合科藝佈展使用的 raspberry pi 工具集。
* 目前假想狀況是: 持續重複撥放一段影片，並在影片撥放到特定時間點時能控制一些周邊裝置。

## 使用裝置

* 目前以 Raspberry pi 為主
	* 僅限 pi2, pi zero, pi3, pi4 系列
* OS: 使用 [Raspberry Pi OS](https://zh.wikipedia.org/wiki/Raspberry_Pi_OS) (以前叫做 Raspbian)

## 系統需求

### video

* 能夠方便設定投影機
	* 快速根據需求調整輸出解析度、比率


### audio

* 能夠選擇從 HDMI 輸出或是從耳機孔輸出 (可接喇叭)


### network & maintain

* 能夠隨時連線 pi 做設定
	* 有線方式
	* 無線方式
* 能夠以 usb 更新內容
* 能夠透過網路控制 pi
* 能夠得知目前 pi 的執行狀況


### system flow control

* 能夠一開機就啟動展示用的程序
* 展示用的程序能夠一直循環執行(撥放)


### sensor & event trigger handling

* 能夠快速配置、測試周邊裝置
* 能夠決定影片的觸發時間點、以及觸發後所要做的事情(handling)

... (持續蒐集中)


## 目前進度

- [x] 整理常見需求
- [ ] 找出必要和次要的
- [ ] 先以類似 wiki 的方式整理文件
- [ ] 嘗試將文件的內容以程式實作成工具 (先不求全自動，先求能配合文件說明做到半自動)
