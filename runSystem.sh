DATA_URL=https://vision.in.tum.de/rgbd/dataset/freiburg
ASSOCIATE_URL=https://svncvpr.in.tum.de/cvpr-ros-pkg/trunk/rgbd_benchmark/rgbd_benchmark_tools/src/rgbd_benchmark_tools/associate.py

CURRENT_PATH=$PWD
NODE_PATH=${CURRENT_PATH}/Examples/ROS/ORB_SLAM2_PointMap_SegNetM

getData () {
  wget ${DATA_URL}$2/$1
}

export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:${NODE_PATH}
cd ${NODE_PATH}

mkdir -p data
cd data

[ ! -e associate.py ] && wget ${ASSOCIATE_URL}

sequences=("desk_with_person" "sitting_static" "sitting_xyz" "sitting_halfsphere" "sitting_rpy" "walking_static" "walking_xyz" "walking_halfsphere" "walking_rpy")

index=0
if [ $1 ]
then
  index=$1 
else
  echo "Choose TUM sequence:"
  for sequence in ${sequences[@]}; do
    echo "$index - $sequence"
    (( index += 1 ))
  done
  
  read -p "Sequence index: " index
fi

settings=3
if [ ! $index ]
then
  settings=2
fi

sequence=rgbd_dataset_freiburg${settings}_${sequences[$index]}

if [ ! -d ${sequence} ]
then
  getData ${sequence}.tgz ${settings}
  tar zxvf ${sequence}.tgz
  rm ${sequence}.tgz
fi

python associate.py ${sequence}/rgb.txt ${sequence}/depth.txt > ${sequence}/associate.txt

mkdir -p ${sequence}/results

cd ${CURRENT_PATH} 

roslaunch TUM.launch settings:=${NODE_PATH}/TUM${settings}.yaml sequence:=${NODE_PATH}/data/${sequence}/ association:=${NODE_PATH}/data/${sequence}/associate.txt results_path:=${NODE_PATH}/data/${sequence}/results/
