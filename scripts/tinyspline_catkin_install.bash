#!/bin/bash
set -e  # exit on first error
ROS_VERSION="indigo"
ROS_BASH="/opt/ros/$ROS_VERSION/setup.bash"

install_prerequisites()
{
	# install prerequisites
	sudo apt-get install -y \
		gcc \
		g++ \
		make \
		build-essential 
}

update_cmake()
{
	# update 3.2 to 3.4 
	wget http://www.cmake.org/files/v3.4/cmake-3.4.3.tar.gz 
	tar -xvzf cmake-3.4.3.tar.gz 
	cd cmake-3.4.3/ 
	./configure 
	make 
	sudo make install
	update-alternatives --install /usr/bin/cmake cmake /usr/local/bin/cmake 1 --force
	cd ..
}




build_tinyspline()
{
	# setup ros env
	source $ROS_BASH

	# create catkin workspace
	mkdir -p $HOME/catkin_ws/src
	cd $HOME/catkin_ws/src
	git clone --depth=1 --branch=master https://github.com/ethz-asl/catkin_simple.git
	catkin_init_workspace
	cd -

	# setup catkin workspace
	cd $HOME/catkin_ws/
	catkin_make
	source devel/setup.bash
	cd -

	# copy omplapp_catkin to catkin workspace
	cd ..
	cp -R tinyspline_catkin $HOME/catkin_ws/src
	cd $HOME/catkin_ws/
	
	catkin_make
}


# RUN
update_cmake
build_tinyspline
