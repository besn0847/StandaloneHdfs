Standalone HDFS 
=============
Hadoop is a great project for deep analytics based on the MapReduce features. It also includes a powerful distributed file system designed to ensure that the analytics workloads can locally access the data to be processed to minimize the network bandwidth impact.

I found this filesystem very useful to leverage storage from all my PCs and even from some of my online storage such as S3. However i did not want to deploy the full hadoop stack. Hence my decidion to create a standalone distribution from the 0.20.2 branch (the base one used for 1.0.0).

The idea is very simple : create a lightweight distribution of the Hadoop Namenode and Datanode for both Linux and Windows which does not require Cygwin for that latter operating system. The goal is to have a central Namenode on Linux and to create an online storage cloud with Linux and Windows Datanodes.

I also included few enhancements such as a WebDav server and an Ajax WebDAV explorer.
