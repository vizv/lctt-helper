#!/bin/bash 
##Script for help to "LCTT"	author:jiwenkangatech@foxmail.com

	if which tput >/dev/null 2>&1; then
		ncolors=$(tput colors)
	fi
	if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
		RED="$(tput setaf 1)"
		GREEN="$(tput setaf 2)"
		YELLOW="$(tput setaf 3)"
		BLUE="$(tput setaf 4)"
		BOLD="$(tput bold)"
		NORMAL="$(tput sgr0)"
	else
		RED=""
		GREEN=""
		YELLOW=""
		BLUE=""
		BOLD=""
		NORMAL=""
	fi
		
	if [ -f "/tmp/TranslateProject*" ];then
		cat /dev/null > /tmp/TranslateProject*
	fi
		set -u
#		env | grep "PATH"	//判断PATH,如果为空则填写默认PATH,否则执行一遍
		

##Call_functions
#
	for soft in git
	do
		hash $soft >/dev/null 2>&1 || {
    			echo "Error: $soft is not installed"
	    	exit 1
	}
	done

function enter_dir () {
	wz_n=$(pwd | cut -d / -f 3,4,5,6)
	wz_o="TranslateProject"
	if [[ $wz_n =~ $wz_o  ]]; then
		echo ""
	else
		printf "${RED}"
			echo -n  "Please Run In the \"TranslateProject\" directory" 
			echo ''
		printf "${NORMAL}"
 		        exit
	fi
	}

function maths_now() {
	if [[ -d "./sources/tech/" ]]; then
		tech="./sources/tech/"			
			echo -n $tech 目录共有$($(command -v find)  $tech  -type f | $( command -v grep) -v README.md |  $(command -v wc) -l)个文件
	else
		tech="./sources/tech/"			
		printf "${RED}"
			echo -n "Missing $tech folders"
			echo ''
		printf "${NORMAL}"
		exit
	fi
	if [[ -d "./sources/talk/" ]]; then
		talk="./sources/talk/"
			echo -n $talk 目录共有$($(command -v find)  $talk  -type f | $( command -v grep) -v README.md |  $(command -v wc) -l)个文件
			echo ""
	else
		talk="./sources/talk/"
		printf "${RED}"
			echo -n "Missing $talk folders"
			echo ''
		printf "${NORMAL}"
		exit
	fi
}
function find_translated() {
	$(command -v cat) /dev/null > /tmp/TranslateProject_talk.txt
	$(command -v cat) /dev/null > /tmp/TranslateProject_tech.txt
	##<core>
	for i in Translated translating fanyi 翻译中 申请翻译 
		do
			cd $talk && grep -RHi $i *| grep -v -E "LCTT翻译规范.md",".git" | cut -d ":" -f 1 >> /tmp/TranslateProject_talk.txt && cd ../..
			cd $tech && grep -RHi $i *| grep -v -E "LCTT翻译规范.md",".git" | cut -d ":" -f 1 >> /tmp/TranslateProject_tech.txt && cd ../..
		done
###bug:如文章本身带上述关键字会给屏蔽，晚些可用正则表达解决。
	##</core>
}

function translated(){
	cat /dev/null > /tmp/TranslateProject.txt
	##<core2>
	find $tech -type f |grep -v README.md | grep  -v "$( cat /tmp/TranslateProject_tech.txt  | uniq  | cut -d "/" -f 3 )" >> /tmp/TranslateProject.txt
	find $talk -type f |grep -v README.md | grep  -v "$( cat /tmp/TranslateProject_talk.txt  | uniq  | cut -d "/" -f 3 )" >> /tmp/TranslateProject.txt
	##</core2>

	if [  -s "/tmp/TranslateProject+" ];then
		printf "${RED}"
			echo -n "Pelease \"rm -rf /tmp/TranslateProject*\" "
			echo ''
		printf "${NORMAL}"
	else
		TranslateProject_talk=$(cat /tmp/TranslateProject_talk.txt | wc -l)
		TranslateProject_tech=$(cat /tmp/TranslateProject_tech.txt | wc -l)
	fi

	if [  $TranslateProject_talk "<" 9 ];then			#One_bug
			echo $talk 有0$TranslateProject_talk个 “LCTTer” 向您致以敬意
	else
			echo $talk 有$TranslateProject_talk个 “LCTTer” 向您共同努力
	fi
	
	if [  $TranslateProject_tech "<" 10 ];then
			echo $tech 有0$TranslateProject_tech个 “LCTTer” 与您执以敬意
	else
			echo $tech 有$TranslateProject_tech个 “LCTTer” 与您共同努力
	fi
}
function no_translate() {
	cat /tmp/TranslateProject.txt | tail
}

##Other_functions
function check_language() {
chk_Language="$(export | grep LANG)"	#必须用LANG判断，采用LC_ALL会造成Opensuse用户无法使用
	if   [[ $chk_Language =~ "zh_CN.UTF-8" ]];then
		Lanaguage=Chinese
	elif [[ $chk_Language =~ "zh_TW.UTF-8" ]];then
		Lanaguage=Chinese
	elif [[ $chk_Language =~ "en_US.UTF-8" ]];then
		Lanaguage=English
		export LC_ALL="zh_CN.UTF-8"	#帮助更改为中文，后续看情况是否还原
	elif [[ $chk_Lanaguag =~ "C" ]];then
		Lanaguage=English
		export LC_ALL="zh_CN.UTF-8"	#帮助更改为中文，后续看情况是否还原
	else
		printf "${RED}"
		echo "Error:unknow Lanaguage"
		echo "Continue or exit (the program will continue after 5s)" 	
		printf "${NORMAL}" && sleep 5s
	fi
}

function first_display() {
	$(command -v echo) -e "\n" 
	$(command -v echo) -e "\033[37;33;5m$(cat LCTT翻译规范.md | head -n 1)\033[39;49;0m"
	cat LCTT翻译规范.md | grep -vi \#
	$(command -v echo) -e "\n" 
        $(command -v echo) -e "\e[1;42m Press any key to continue \e[0m"
	read
}

function time_now() {
	date "+今星期%a: %y-%m-%d 当前时间: %T"
}

##Main_Code
check_language	# 检查 ”LCTTer“ 环境是否为中文(是否能正常显示中文)
enter_dir	# 确定 ”LCTTer“ 在 “TranslateProject” 目录
first_display	# 展示 “Linux中国翻译规范” 文件
time_now	# 显示 ”LCTTer“ 当前时间(为避免上述文件长期显示无意义)
maths_now	# 告知 “LCTTer” 总共有多少文章（全部）
find_translated	# 综合 "KeyWord" 至 /tmp/TranslateProject.txt 文件
translated	# 告知 “LCTTer” 剩余有多少文章（被翻译）	
echo -e "\e[1;42m\n以下为筛选结果，请挑选进行翻译\e[0m" && read 
no_translate	# 告知 “LCTTer” 剩余有多少文章（未翻译）
exit 0		# 完成操作，正确 (状态码 0 ) 退出。

##Test_Code
#
#cat /tmp/TranslateProject.txt | sed -s 's/^/cat\ "/;s/$/"\|\ \ head\ \-n\ 1/' > /tmp/test.sh && sh /tmp/test.sh
