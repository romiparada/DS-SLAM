ASSOCIATE_URL=https://svncvpr.in.tum.de/cvpr-ros-pkg/trunk/rgbd_benchmark/rgbd_benchmark_tools/src/rgbd_benchmark_tools/associate.py

CURRENT_PATH=$PWD
NODE_PATH=${CURRENT_PATH}/Examples/ROS/ORB_SLAM2_PointMap_SegNetM
DATA_PATH=$HOME/remote_data
ASSOCIATION_PATH=$HOME/data

export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:${NODE_PATH}
cd $ASSOCIATION_PATH

[ ! -e associate.py ] && wget ${ASSOCIATE_URL}

DATA_PATH=$DATA_PATH/BONN
cd $DATA_PATH 

sequences=("crowd" "moving_nonobstructing_box" "person_tracking" "placing_nonobstructing_box")

index=0
if [ $1 ]
then
  index=$1 
else
  echo "Choose BONN sequence:"
  for sequence in ${sequences[@]}; do
    echo "$index - $sequence"
    (( index += 1 ))
  done
  
  read -p "Sequence index: " index
fi

sequence=rgbd_bonn_${sequences[$index]}

if [ ! -d ${sequence} ]
then
  unzip ${sequence}.zip
  rm ${sequence}.zip
fi

python $ASSOCIATION_PATH/associate.py ${sequence}/rgb.txt ${sequence}/depth.txt > ${sequence}/associate.txt



cd ${CURRENT_PATH} 
mkdir -p data/BONN/${sequence}/results

settings=${NODE_PATH}/Bonn.yaml 
association=${DATA_PATH}/${sequence}/associate.txt 
results_path=${CURRENT_PATH}/data/BONN/${sequence}/results/
sequence=${DATA_PATH}/${sequence}/ 

roslaunch TUM.launch settings:=${settings} sequence:=${sequence} association:=${association} results_path:=${results_path}
