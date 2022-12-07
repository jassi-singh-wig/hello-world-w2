#! /bin/bash

exec >> /var/log/user-data.log 2>&1

HOME="/home/ec2-user"

# VERSION=1:8.5.0-1

# cd $HOME
# wget https://artifacts.elastic.co/downloads/logstash/logstash-$VERSION-linux-x86_64.tar.gz 
# tar -zxvf  $HOME/logstash-$VERSION-linux-x86_64.tar.gz
# cd $HOME/logstash-$VERSION

# https://www.elastic.co/guide/en/logstash/current/installing-logstash.html#_yum

rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

cat <<EOF > /etc/yum.repos.d/logstash.repo
[logstash-8.x]
name=Elastic repository for 8.x packages
baseurl=https://artifacts.elastic.co/packages/8.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

# sudo yum repolist 
# sudo yum repo-pkgs logstash-8.x list
sudo yum install logstash -y 


# https://www.elastic.co/guide/en/logstash/current/multiple-pipelines.html

cat <<EOF > /etc/logstash/pipelines.yml
- pipeline.id: start-pipeline
  path.config: "/etc/logstash/conf.d/p1.conf"
  pipeline.workers: 3
- pipeline.id: process-pipeline
  path.config: "/etc/logstash/conf.d/p2.conf"
  queue.type: persisted
- pipeline.id: final-pipeline
  path.config: "/etc/logstash/conf.d/p3.conf"
  queue.type: persisted
EOF

cat <<EOF > /etc/logstash/conf.d/p1.conf
input {
  file {
    id => "my_file"
    path => "$HOME/hello-world/test.txt"
  }
}

output {
 pipeline { send_to => processor }
}
EOF


cat <<EOF > /etc/logstash/conf.d/p2.conf
input {
  pipeline { address => processor }
}


output {
 pipeline { send_to => output }
}
EOF


cat <<EOF > /etc/logstash/conf.d/p3.conf
input {
  pipeline { address => output }

}


output {
 file {
    path => "/tmp/output-logstash.logs"
  }
}
EOF




mkdir $HOME/hello-world

cat <<EOF > $HOME/hello-world/test.txt
{"@timestamp":"2022-11-28T14:55:36.468Z", "log.level": "WARN", "message":"monitoring execution failed", "ecs.version": "1.2.0","service.name":"ES_ECS","event.dataset":"elasticsearch.server","process.thread.name":"Thread-0","log.logger":"org.elasticsearch.xpack.monitoring.MonitoringService","elasticsearch.cluster.uuid":"QQtPPy5IQ7ic4nqDuKCbQA","elasticsearch.node.id":"GjCqOccEQCuBalfzf_bV9A","elasticsearch.node.name":"MC02F6593MD6R","elasticsearch.cluster.name":"elasticsearch","error.type":"org.elasticsearch.xpack.monitoring.exporter.ExportException","error.message":"failed to flush export bulks","error.stack_trace":"org.elasticsearch.xpack.monitoring.exporter.ExportException: failed to flush export bulks\n\tat org.elasticsearch.xpack.monitoring.exporter.ExportBulk$Compound.lambda$doFlush$0(ExportBulk.java:110)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.action.ActionListener$2.onFailure(ActionListener.java:170)\n\tat org.elasticsearch.xpack.monitoring.exporter.local.LocalBulk.throwExportException(LocalBulk.java:135)\n\tat org.elasticsearch.xpack.monitoring.exporter.local.LocalBulk.lambda$doFlush$0(LocalBulk.java:110)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.action.ActionListener$2.onResponse(ActionListener.java:162)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.action.support.ContextPreservingActionListener.onResponse(ContextPreservingActionListener.java:31)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.client.internal.node.NodeClient$SafelyWrappedActionListener.onResponse(NodeClient.java:160)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.tasks.TaskManager$1.onResponse(TaskManager.java:208)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.tasks.TaskManager$1.onResponse(TaskManager.java:202)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.action.ActionListener$RunBeforeActionListener.onResponse(ActionListener.java:415)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.action.bulk.TransportBulkAction$BulkOperation$1.finishHim(TransportBulkAction.java:612)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.action.bulk.TransportBulkAction$BulkOperation$1.onFailure(TransportBulkAction.java:607)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.client.internal.node.NodeClient$SafelyWrappedActionListener.onFailure(NodeClient.java:170)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.tasks.TaskManager$1.onFailure(TaskManager.java:217)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.action.support.replication.TransportReplicationAction$ReroutePhase.finishAsFailed(TransportReplicationAction.java:1041)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.action.support.replication.TransportReplicationAction$ReroutePhase$2.onClusterServiceClose(TransportReplicationAction.java:1026)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.cluster.ClusterStateObserver$ContextPreservingListener.onClusterServiceClose(ClusterStateObserver.java:338)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.cluster.ClusterStateObserver$ObserverClusterStateListener.onClose(ClusterStateObserver.java:245)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.cluster.service.ClusterApplierService.addTimeoutListener(ClusterApplierService.java:254)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.cluster.ClusterStateObserver.waitForNextChange(ClusterStateObserver.java:177)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.cluster.ClusterStateObserver.waitForNextChange(ClusterStateObserver.java:118)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.cluster.ClusterStateObserver.waitForNextChange(ClusterStateObserver.java:110)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.action.support.replication.TransportReplicationAction$ReroutePhase.retry(TransportReplicationAction.java:1018)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.action.support.replication.TransportReplicationAction$ReroutePhase$1.handleException(TransportReplicationAction.java:997)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.transport.TransportService$ContextRestoreResponseHandler.handleException(TransportService.java:1372)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.transport.TransportService.doStop(TransportService.java:362)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.common.component.AbstractLifecycleComponent.stop(AbstractLifecycleComponent.java:63)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.node.Node.stop(Node.java:1435)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.node.Node.close(Node.java:1454)\n\tat org.elasticsearch.base@8.5.0/org.elasticsearch.core.IOUtils.close(IOUtils.java:71)\n\tat org.elasticsearch.base@8.5.0/org.elasticsearch.core.IOUtils.close(IOUtils.java:87)\n\tat org.elasticsearch.base@8.5.0/org.elasticsearch.core.IOUtils.close(IOUtils.java:63)\n\tat org.elasticsearch.server@8.5.0/org.elasticsearch.bootstrap.Elasticsearch.shutdown(Elasticsearch.java:446)\n\tat java.base/java.lang.Thread.run(Thread.java:1589)\nCaused by: org.elasticsearch.xpack.monitoring.exporter.ExportException: bulk [default_local] reports failures when exporting documents\n\tat org.elasticsearch.xpack.monitoring.exporter.local.LocalBulk.throwExportException(LocalBulk.java:124)\n\t... 31 more\n"}
{"@timestamp":"2022-11-28T14:55:39.428Z", "log.level": "INFO", "message":"stopped", "ecs.version": "1.2.0","service.name":"ES_ECS","event.dataset":"elasticsearch.server","process.thread.name":"Thread-0","log.logger":"org.elasticsearch.node.Node","elasticsearch.cluster.uuid":"QQtPPy5IQ7ic4nqDuKCbQA","elasticsearch.node.id":"GjCqOccEQCuBalfzf_bV9A","elasticsearch.node.name":"MC02F6593MD6R","elasticsearch.cluster.name":"elasticsearch"}
EOF

chmod -R 777 $HOME/hello-world/

# $HOME/logstash-$VERSION/bin/logstash #-f $HOME/hello-world/config-file.conf 

systemctl start logstash.service
