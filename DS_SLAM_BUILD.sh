export Caffe_Segnet_PATH="~/catkin_ws/DS-SLAM/Examples/ROS/ORB_SLAM2_PointMap_SegNetM/caffe-segnet-cudnn7"

echo "Configuring and building Thirdparty/DBoW2 ..."

cd Thirdparty/DBoW2
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make 

cd ../../g2o

echo "Configuring and building Thirdparty/g2o ..."

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make 

cd ../../../

echo "Configuring and building libsegmentation.so ..."

cd Examples/ROS/ORB_SLAM2_PointMap_SegNetM/libsegmentation
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make 

cd ../../../../../

echo "Configuring and building libORB_SLAM2_PointMap_SegNetM.so ..."

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make 

cd ..


echo "Configuring and building Executable TUM ..."

cd Examples/ROS/ORB_SLAM2_PointMap_SegNetM
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make 

cd ../../../../



