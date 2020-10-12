## topics

根據需求 breakdown 所需的知識

* 如何安裝 pi
	* 該選擇哪一種 OS
		* 視窗版
		* Lite 版 -- 只能打指令
* 安裝後的環境設定
	* 安裝套件
	* 設定 shell -> bash
	* 設定顯示
	* 啟動網路服務 -- ssh
* 如何連到 pi -- 使用 ssh
	* 如何查 ip -- ifconfig
	* 如何確認主機是否活著 -- ping
* 如何撥放 video -- 使用 omxplayer
	* 如何選擇輸出 hdmi/耳機孔
	* 如何控制播放
		* 快轉
		* 音量
		* 重複播放
		* 播放目錄下的所有檔案
			* 檔案之間的間隔處理
	* 如何抓到目前撥放的進度 -- dbus
		* 使用 dbuscontrol.sh
* 開機後自動啟動程式的方法
	* 透過 systemd
	* 透過 rc.local
