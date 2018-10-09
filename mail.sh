#!/bin/bash
## | requirement system
## | - telah di coba di RHEL, CentOS hasil sukses, untuk distro lain belum ada tes
## | - sendmail, mailx, procmail
## | - internet
## | - ------

## var
logdir="/rss/logs/"
#date=date + "%Y-%m-%d"

## konfigurasi smtp
smtpserv="smtp.gmail.com:587"
smtpuser="youremail@gmail.com"
smtppass="myemail123*"

## konfigurasi sender email
from="logadmin@centos7.dev"
subject="[REPORT] Log Transaction"

## konfigurasi primary mail receiver
mailto="mailto@gmail.com"

## konten pesan dalam body email
body="Berikut data logs, untuk dapat digunakan sebagai mana mestinya. Berikut file terlampir."

## file logs-nya
# logfnd="logs/log_find.ini"
# logadd="logs/log_add.ini"
# logdel="logs/log_delete.ini"
# logupd="logs/log_update.ini"
alogs=$logdir"logs.ini"

## file logs backup-nya
# bcfnd="logs/log_log_find_"
# bcadd="logs/log_log_add_"
# bcdel="logs/log_log_delete_"
# bcupd="logs/log_log_update_"
blogs=$logdir"log_logs_"

input="yes"
while [[ $input = "yes" ]]
do
    PS3="Tekan [1]Kirim log hari ini [2]Quit. Pilihan ?: "
    select logs in Sendlog Quit
    do
        case "$logs" in
        Sendlog)
            echo "Masukkan tanggal e.g 2018-08-17, tekan [enter] untuk mengirim log hari ini [date]: "
            read date
            if [ "$date" == "" ];then
                if [ -f "$alogs" ];then
                    mail -vvv \
                        -r "$from" \
                        -s "$subject" \
                        -S smtp="$smtpserv" \
                        -S smtp-use-starttls \
                        -S smtp-auth=login \
                        -S smtp-auth-user="$smtpuser" \
                        -S smtp-auth-password="$smtppass" \
                        -S ssl-verify=ignore \
                        -S nss-config-dir=/etc/pki/nssdb/ \
                        -a $alogs \
                    $mailto `cat maildest.txt` <<< $body
                    echo "Status: $alogs -> Log file ditemukan, file dikirim!"
                else
                    echo "Status: File tidak ditemukan!"
                    break
                fi
            else
                if [ -f $blogs$date.ini ];then
                    mail -vvv \
                       -r "$from" 
                       -s "$subject" 
                       -S smtp="$smtpserv" 
                       -S smtp-use-starttls 
                       -S smtp-auth=login 
                       -S smtp-auth-user="$smtpuser" 
                       -S smtp-auth-password="$smtppass" 
                       -S ssl-verify=ignore 
                       -S nss-config-dir=/etc/pki/nssdb/ \
                       -a $blogs$date.ini \
                    $mailto `cat maildest.txt` <<< $body
                    echo "Status: $blogs -> Backup log file ditemukan, file dikirim!"
                else
                    echo "Status: File tidak ditemukan!"
                    break
                fi
            fi
            # echo Response: File telah dikirim!
            break
        ;;

        Quit) exit ;;
        *)
            echo Choose 1 to 2 only !!!!
            break
        ;;
    esac
    done

done