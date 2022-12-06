#! /bin/bash

exec >> /var/log/user-data.log 2>&1

whoami

echo "Hello World!"

sudo -u ec2-user -i 

whoami

# VERSION=8.5.2

# wget https://artifacts.elastic.co/downloads/logstash/logstash-$VERSION-linux-x86_64.tar.gz $HOME/
# tar -zxvf  $HOME/logstash-$VERSION-linux-x86_64.tar.gz
# cd $HOME/logstash-$VERSION

# mkdir $HOME/hello-world

# # https://www.elastic.co/guide/en/logstash/current/multiple-pipelines.html

# cat <<EOF > $HOME/logstash-$VERSION/config/pipelines.yml
# - pipeline.id: start-pipeline
#   path.config: "/$HOME/hello-world/p1.conf"
#   pipeline.workers: 3
# - pipeline.id: process-pipeline
#   path.config: "/$HOME/hello-world/p2.conf"
#   queue.type: persisted
# - pipeline.id: final-pipeline
#   path.config: "/$HOME/hello-world/p3.conf"
#   queue.type: persisted
# EOF


# # https://www.elastic.co/guide/en/logstash/current/pipeline-to-pipeline.html#distributor-pattern



# cat <<EOF > $HOME/hello-world/p1.conf
# input {
#   file {
#     id => "my_file"
#     path => "$HOME/hello-world/input-folder/*.txt"
#   }
# }

# output {
#  pipeline { send_to => processor }
# }
# EOF


# cat <<EOF > $HOME/hello-world/p2.conf
# input {
#   pipeline { address => processor }
# }

# filter {
#     mutate {
#     capitalize => [ "message.log.level" ]
#     }
# }


# output {
#  pipeline { send_to => output }
# }
# EOF


# cat <<EOF > $HOME/hello-world/p3.conf
# input {
#   pipeline { address => output }

# }


# output {
#  file {
#     path => "$HOME/hello-world/output.txt"
#   }
# }
# EOF

# $HOME/logstash-$VERSION/bin/logstash #-f $HOME/hello-world/config-file.conf 
