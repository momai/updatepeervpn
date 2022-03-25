
#!/bin/bash
user=momai

#repo IP
dirs=('192.168.1.44' '192.168.1.45')


ssh-keygen -t rsa -q -f "$HOME/.ssh/id_rsa" -N ""

for j in ${dirs[@]}
do
echo $user@$j

ssh-copy-id  $user@$j
scp repo $user@$j:/home/$user/
ssh -t $user@$j sudo cp repo /etc/sudoers.d/

done
