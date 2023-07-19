 #!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================================#
#   System Required: CentOS7 X86_64                               #
#   Description: FFmpeg Stream Media Server                       #
#   Author: LALA                                    #
#   Website: https://www.lala.im                                  #
#=================================================================#

# ��ɫѡ��
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
font="\033[0m"

ffmpeg_install(){
# ��װFFMPEG
read -p "��Ļ������Ƿ��Ѿ���װ��FFmpeg4.x?��װFFmpeg������������,�Ƿ����ڰ�װFFmpeg?(yes/no):" Choose
if [ $Choose = "yes" ];then
	yum -y install wget
	wget --no-check-certificate https://www.johnvansickle.com/ffmpeg/old-releases/ffmpeg-4.0.3-64bit-static.tar.xz
	tar -xJf ffmpeg-4.0.3-64bit-static.tar.xz
	cd ffmpeg-4.0.3-64bit-static
	mv ffmpeg /usr/bin && mv ffprobe /usr/bin && mv qt-faststart /usr/bin && mv ffmpeg-10bit /usr/bin
fi
if [ $Choose = "no" ]
then
    echo -e "${yellow} ��ѡ�񲻰�װFFmpeg,��ȷ����Ļ������Ѿ����а�װ��FFmpeg,��������޷���������! ${font}"
    sleep 2
fi
	}

stream_start(){
# ����������ַ��������
read -p "�������������ַ��������(rtmpЭ��):" rtmp

# �ж��û�����ĵ�ַ�Ƿ�Ϸ�
if [[ $rtmp =~ "rtmp://" ]];then
	echo -e "${green} ������ַ������ȷ,���򽫽�����һ������. ${font}"
  	sleep 2
	else  
  	echo -e "${red} ������ĵ�ַ���Ϸ�,���������г�������! ${font}"
  	exit 1
fi 

# ������Ƶ���Ŀ¼
read -p "���������Ƶ���Ŀ¼ (��ʽ��֧��mp4,����Ҫ����·��,����/opt/video):" folder

# �ж��Ƿ���Ҫ���ˮӡ
read -p "�Ƿ���ҪΪ��Ƶ���ˮӡ?ˮӡλ��Ĭ�������Ϸ�,��Ҫ�Ϻ�CPU֧��(yes/no):" watermark
if [ $watermark = "yes" ];then
	read -p "�������ˮӡͼƬ��ž���·��,����/opt/image/watermark.jpg (��ʽ֧��jpg/png/bmp):" image
	echo -e "${yellow} ���ˮӡ���,���򽫿�ʼ����. ${font}"
	# ѭ��
	while true
	do
		cd $folder
		for video in $(ls *.mp4)
		do
		ffmpeg -re -i "$video" -i "$image" -filter_complex overlay=W-w-5:5 -c:v libx264 -c:a aac -b:a 192k -strict -2 -f flv ${rtmp}
		done
	done
fi
if [ $watermark = "no" ]
then
    echo -e "${yellow} ��ѡ�����ˮӡ,���򽫿�ʼ����. ${font}"
    # ѭ��
	while true
	do
		cd $folder
		for video in $(ls *.mp4)
		do
		ffmpeg -re -i "$video" -c:v copy -c:a aac -b:a 192k -strict -2 -f flv ${rtmp}
		done
	done
fi
	}

# ֹͣ����
stream_stop(){
	screen -S stream -X quit
	killall ffmpeg
	}

# ��ʼ�˵�����
echo -e "${yellow} CentOS7 X86_64 FFmpeg����ֵ��ѭ������ For LALA.IM ${font}"
echo -e "${red} ��ȷ���˽ű�Ŀǰ����screen���������е�! ${font}"
echo -e "${green} 1.��װFFmpeg (����Ҫ��װFFmpeg������������) ${font}"
echo -e "${green} 2.��ʼ����ֵ��ѭ������ ${font}"
echo -e "${green} 3.ֹͣ���� ${font}"
start_menu(){
    read -p "����������(1-3),ѡ����Ҫ���еĲ���:" num
    case "$num" in
        1)
        ffmpeg_install
        ;;
        2)
        stream_start
        ;;
        3)
        stream_stop
        ;;
        *)
        echo -e "${red} ��������ȷ������ (1-3) ${font}"
        ;;
    esac
	}