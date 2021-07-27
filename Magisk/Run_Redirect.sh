#!/system/bin/sh
# Cloud Configuration
# 酷安@阿巴酱(Petit Abba)
# 所有路径都已验证(√)
Version="202107260220"

#绝对路径
if [[ -d /data/adb/modules/Third_Party_Redirect ]]; then
	#Magisk
	Absolute_Path="/data/adb/modules/Third_Party_Redirect"
else
	#Magisk Lite
	Absolute_Path="/data/adb/lite_modules/Third_Party_Redirect"
fi

MODDIR="$(dirname $(readlink -f "$0"))"
[[ -f $MODDIR/files/Variable.sh ]] && . $MODDIR/files/Variable.sh
[[ -d /storage/emulated/0/Download ]] && path="Download" || path="download"
[[ ! -z $(which curl) ]] && Binary_System="$(which curl)" || Binary_System="$(which wget)"
MyPrintt() { [[ "$MODDIR" == "$Absolute_Path" ]] && echo "$@" > $DirectionalPath/$Version.txt ; }
MyPrint() { [[ "$MODDIR" == "$Absolute_Path" ]] && echo "$@" >> $DirectionalPath/$Version.txt || echo "$@" ; }

DirectionalPath="/storage/emulated/0/$path/第三方应用下载目录/-定向记录与配置"
[[ ! -d $DirectionalPath ]] && mkdir -p $DirectionalPath
[[ ! -f $DirectionalPath/-定向黑名单.conf ]] && { echo '# 把不需要定向的文件夹名称填写进来（一行一个）

OFF="
#举两个例子
微信
网易云音乐

"' > $DirectionalPath/-定向黑名单.conf
}

[[ "$MODDIR" == "$Absolute_Path" ]] && [[ ! -d $DirectionalPath ]] && mkdir -p $DirectionalPath
[[ "$MODDIR" == "$Absolute_Path" ]] && [[ ! -f $DirectionalPath/$Version.txt ]] && MyPrintt "BinaryFile: $Binary_System
你的设备: $(getprop ro.product.manufacturer) $(getprop ro.product.model) 安卓$(getprop ro.build.version.release)
模块名称: $(cat "$MODDIR/module.prop" | grep 'name=' | awk -F '=' '{print $2}')
模块版本: $(cat "$MODDIR/module.prop" | grep 'version=' | awk -F '=' '{print $2}')
文件版本: $Version
云端同步: $(date "+%Y-%m-%d %H:%M")

查看说明: 
[1]＝[ 定向成功 ]
[0]＝[ 存在这个路径 但识别到该路径没有用户下载的文件 所以不执行定向 ]
[rm]＝[ 删除指定路径空文件夹 ]
[off] = [ 跳过定向 ]

关于反馈:
请将此页面截图并说明问题

更新内容:
#202107260220
Chrome /storage/emulated/0/Android/data/com.android.chrome/files/Download

#202107211340
存储空间隔离后的TIM目录
存储空间隔离后的皮皮虾目录
日志兼容Magisk_Lite
"
MyPrint ">>开始执行<<"

# 影响正确判断用户是否下载文件到目录的无用文件夹
Dung=".tmp
.thumbnails
.trooptmp
.Application"

source $DirectionalPath/-定向黑名单.conf

#应用
Download() {
	local a="/data/media/0/$2"
	local aa="/data/media/0/Android/data/$2"
	local aaa="$2"
	local b="/data/media/0/$path/第三方应用下载目录/$1"
	local c="/storage/emulated/0/$path/第三方应用下载目录/$1"

	UMOUNT() {
		umount $a >/dev/null 2>&1
		umount $aa >/dev/null 2>&1
		umount $aaa >/dev/null 2>&1
		umount $b >/dev/null 2>&1
		umount $c >/dev/null 2>&1
	}

	for NonExecution in $OFF; do
		if [[ $1 == $NonExecution ]]; then
			[[ ! -z $a ]] && [[ -d $a ]] && MyPrint "$(date "+[%Y-%m-%d %H:%M:%S]"):[off] $1($a)"
			[[ ! -z $aa ]] && [[ -d $aa ]] && MyPrint "$(date "+[%Y-%m-%d %H:%M:%S]"):[off] $1($aa)"
			[[ ! -z $aaa ]] && [[ -d $aaa ]] && MyPrint "$(date "+[%Y-%m-%d %H:%M:%S]"):[off] $1($aaa)"
			if [[ -d $b ]]; then
				UMOUNT
				rm -rf $b && MyPrint "$(date "+[%Y-%m-%d %H:%M:%S]"):[rm] $b"
			fi
			return
		fi
	done

	PathLink() {
		if [[ "$(ls -A "${L//'?'/' '}")" == "" ]]; then
			if [[ -d $b ]]; then
				UMOUNT
				rm -rf $b && return 2
			fi
			return 0
		else
			[[ ! -d "$b" ]] && mkdir -p "$b"
			mount --bind "$L" "$b"
			mount --bind "$L" "$c"
			chcon u:object_r:media_rw_data_file:s0 "$L"
			chmod 777 "$b"
			chown media_rw:media_rw "$b"
			chown media_rw:media_rw "$c"
			return 1
		fi
	}

	if [[ -d $a ]]; then
		L="$a"
		PathLink
		[[ $? == 1 ]] && MyPrint "$(date "+[%Y-%m-%d %H:%M:%S]"):[1] $1($L)" || MyPrint "$(date "+[%Y-%m-%d %H:%M:%S]"):[0] $1($L)"
		[[ $? == 2 ]] && MyPrint "$(date "+[%Y-%m-%d %H:%M:%S]"):[rm] $b"
	elif [[ -d $aa ]]; then
		L="$aa"
		PathLink
		[[ $? == 1 ]] && MyPrint "$(date "+[%Y-%m-%d %H:%M:%S]"):[1] $1($L)" || MyPrint "$(date "+[%Y-%m-%d %H:%M:%S]"):[0] $1($L)"
		[[ $? == 2 ]] && MyPrint "$(date "+[%Y-%m-%d %H:%M:%S]"):[rm] $b"
	elif [[ -d $aaa ]]; then
		L="$aaa"
		PathLink
		[[ $? == 1 ]] && MyPrint "$(date "+[%Y-%m-%d %H:%M:%S]"):[1] $1($L)" || MyPrint "$(date "+[%Y-%m-%d %H:%M:%S]"):[0] $1($L)"
		[[ $? == 2 ]] && MyPrint "$(date "+[%Y-%m-%d %H:%M:%S]"):[rm] $b"
	fi
}

#音乐类
Music() {
	local a="/data/media/0/$3"
	local aa="/data/media/0/Android/data/$3"
	local b="/data/media/0/$path/Center/$1/$2"
	local c="/storage/emulated/0/$path/Center/$1/$2"

	UMOUNT() {
		umount $a >/dev/null 2>&1
		umount $aa >/dev/null 2>&1
		umount $b >/dev/null 2>&1
		umount $c >/dev/null 2>&1
	}

	for NonExecution_a in $OFF; do
		if [[ $1 == $NonExecution_a ]]; then
			[[ ! -z $a ]] && [[ -d $a ]] && MyPrint "$(date "+[%Y-%m-%d %H:%M:%S]"):[off] $1($a)"
			[[ ! -z $aa ]] && [[ -d $aa ]] && MyPrint "$(date "+[%Y-%m-%d %H:%M:%S]"):[off] $1($aa)"
			if [[ -d $b ]]; then
				UMOUNT
				rm -rf $b && MyPrint "$(date "+[%Y-%m-%d %H:%M:%S]"):[rm] $b"
			fi
			return
		fi
	done

	MusicLink() {
		if [[ "$(ls -A "${M//'?'/' '}")" == "" ]]; then
			if [[ -d $b ]]; then
				UMOUNT
				rm -rf $b && return 2
			fi
			return 0
		else
			[[ ! -d "$b" ]] && mkdir -p "$b"
			mount --bind "$M" "$b"
			mount --bind "$M" "$c"
			chcon u:object_r:media_rw_data_file:s0 "$M"
			chmod 777 "$b"
			chown media_rw:media_rw "$b"
			chown media_rw:media_rw "$c"
			return 1
		fi
	}

	if [[ -d $a ]]; then
		M="$a"
		MusicLink
		[[ $? == 1 ]] && MyPrint "$(date "+[%Y-%m-%d %H:%M:%S]"):[1] $1/$2($M)" || MyPrint "$(date "+[%Y-%m-%d %H:%M:%S]"):[0] $1/$2($M)"
		[[ $? == 2 ]] && MyPrint "$(date "+[%Y-%m-%d %H:%M:%S]"):[rm] $b"
	elif [[ -d $aa ]]; then
		M="$aa"
		MusicLink
		[[ $? == 1 ]] && MyPrint "$(date "+[%Y-%m-%d %H:%M:%S]"):[1] $1/$2($M)" || MyPrint "$(date "+[%Y-%m-%d %H:%M:%S]"):[0] $1/$2($M)"
		[[ $? == 2 ]] && MyPrint "$(date "+[%Y-%m-%d %H:%M:%S]"):[rm] $b"
	fi
}

# 音乐类(含存储空间隔离后目录)
Music "网易云音乐" "歌曲" "netease/cloudmusic/Music"
Music "网易云音乐" "歌曲" "com.netease.cloudmusic/sdcard/netease/cloudmusic/Music"
Music "网易云音乐" "歌曲" "com.netease.cloudmusic/cache/sdcard/netease/cloudmusic/Music"
Music "网易云音乐" "MV" "netease/cloudmusic/MV"
Music "网易云音乐" "MV" "com.netease.cloudmusic/sdcard/netease/cloudmusic/MV"
Music "网易云音乐" "MV" "com.netease.cloudmusic/cache/sdcard/netease/cloudmusic/MV"

yywjj="/data/media/0/$path/Center"
yywjj_a="/storage/emulated/0/$path/Center"
if [[ -d $yywjj ]]; then
	for yy in `ls -A $yywjj`; do
		yykwjj="$yywjj/$yy"
		yykwjj_a="$yywjj_a/$yy"
		if [[ "$(ls -A "${yykwjj//'?'/' '}")" == "" ]]; then
			if [[ -d $yykwjj ]]; then
				umount $yykwjj >/dev/null 2>&1
				umount $yykwjj_a >/dev/null 2>&1
				rm -rf $yykwjj && MyPrint "$(date "+[%Y-%m-%d %H:%M:%S]"):[rm] $yykwjj"
			fi
		fi
	done
fi

wjj="/data/media/0/$path/第三方应用下载目录/*
/storage/emulated/0/$path/第三方应用下载目录/*"

for i in `ls -d $wjj`; do
	kwjj=$i
	if [[ "$(ls -A "${kwjj//'?'/' '}" 2>/dev/null)" == "" ]]; then
		if [[ -d $kwjj ]]; then
			umount $kwjj >/dev/null 2>&1
			rm -rf $kwjj 2>/dev/null && MyPrint "$(date "+[%Y-%m-%d %H:%M:%S]"):[rm] $kwjj"
		fi
	fi
done

MyPrint ">>执行完毕<<"

echo "#!/system/bin/sh
	if [[ -f $DirectionalPath/-定向黑名单.conf.bak ]]; then
		rm -rf $DirectionalPath/-定向黑名单.conf.bak
	fi

	{
		source $0
	}&

	{
		sh $0
	}&
" > $DirectionalPath/-一键执行.sh

sleep 10
