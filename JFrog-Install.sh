
# 1. Update your package manager 
sudo apt update

# 2. switch to root user
sudo su -

# 3. Navigate to the target install dir/folder
cd /opt

# 4. Download jfrog-artifactory packaged file for install
wget https://releases.jfrog.io/artifactory/bintray-artifactory/org/artifactory/oss/jfrog-artifactory-oss/7.9.2/jfrog-artifactory-oss-7.9.2-linux.tar.gz

# 5. Unpack the packed file
tar -xvf jfrog-artifactory-oss-7.9.2-linux.tar.gz

# 6. Navigate to the bin dir of unpack folder
cd artifactory-oss-7.9.2/app/bin/

# 7. Run artifactory.sh file by passing start input for starting the jfrog service
./artifactory.sh start


# [OPTIONAL] : To install specific version of jfrog-artifactory-oss, visit this link to copy the path link of that tar.gz file: https://releases.jfrog.io/artifactory/bintray-artifactory/org/artifactory/oss/jfrog-artifactory-oss/
# Once you copied the link, then you just need to replace the download link from step no. 4, and all steps will remain same.


