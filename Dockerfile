FROM julia:1.7.3

# HTTP port
EXPOSE 8000
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install git -y
# add a new user called "MLCourse"
RUN useradd -ms /bin/bash MLCourse
# set the current directory
WORKDIR /home/MLCourse
# run the rest of commands as MLCourse user
USER MLCourse
RUN git clone https://github.com/jbrea/MLCourse
# copy the contents of the github repository into /home/MLCourse
# COPY --chown=MLCourse . /home/MLCourse
ENV html_export=true
ENV JULIA_PKG_DEVDIR=/home/MLCourse

# Initialize the julia project environment that will be used to run the bind server.
# RUN julia --project=/home/MLCourse -e "import Pkg; Pkg.instantiate(); Pkg.precompile(); using MLCourse"
RUN julia -e 'import Pkg; Pkg.activate(joinpath(Pkg.devdir(), "MLCourse")); Pkg.instantiate(); using MLCourse; cp(MLCourse.PrecompilePlutoCourse._CONFIG[].sysimage_artifact, "/home/MLCourse/MLCourse/precompile/mlcourse.so")'

# The "default command" for this docker thing.
CMD ["julia", "-J/home/MLCourse/MLCourse/precompile/mlcourse.so", "--project=/home/MLCourse/MLCourse", "-e", "import PlutoSliderServer; PlutoSliderServer.run_git_directory(\".\"; Export_baked_notebookfile = false, SliderServer_port=8000, SliderServer_exclude = [\"extras/transfer_learning.jl\", \"extras/generative_models.jl\"], Export_exclude = [\"extras/transfer_learning.jl\", \"extras/generative_models.jl\"], SliderServer_host=\"0.0.0.0\", Export_slider_server_url=\"https://bio322.epfl.ch/\", Export_binder_url = \"https://mybinder.org/v2/gh/jbrea/MLCourse/binder\")"]
