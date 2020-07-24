#https://stackoverflow.com/questions/36969824/using-anaconda-environments-with-cygwin-on-windows
#  Anaconda Environment Selection - Plese set CONDA_BASE_DIR to the directory
#  containing the base installation of anaconda/miniconda.

export CONDA_BASE_DIR=/cygdrive/d/Anaconda3

#  Proxy Servers & Network Setup (if needed)

export HTTP_PROXY=
export HTTPS_PROXY=

#  IMPORTANT - Ignore carriage returns when using a Cygwin environment.

export SHELLOPTS
set -o igncr

###############################################################################

#  Manage conda environments for Python.  We check the environment variable
#  $CONDA_DEFAULT_ENV to see which environment is desired.  The default (root)
#  environment will be chosen if nothing is specified.  Note that this variable
#  will be explicitly managed by the cyg-activate ( ) function we have defined
#  below, specifically for the purpose of changing environments.  The root
#  environment is also handled slightly different from the others when it comes
#  to setting the CONDA_DEFAULT_ENV variable.

#if [ ${CONDA_DEFAULT_ENV} ] && [ ${CONDA_DEFAULT_ENV} != 'root' ] 
if [ ${CONDA_DEFAULT_ENV} ] && [ ${CONDA_DEFAULT_ENV} != 'base' ] 
then
    #  SELECT ONE OF THE NON-DEFAULT ENVIRONMENTS
    export CONDA_PREFIX=${CONDA_BASE_DIR}/envs/${CONDA_DEFAULT_ENV}
else
    #  SELECT THE DEFAULT ENVIRONMENT (and set CONDA_DEFAULT_ENV full path)
    #export CONDA_DEFAULT_ENV=root
    export CONDA_DEFAULT_ENV=base
    export CONDA_PREFIX=${CONDA_BASE_DIR}
fi

###############################################################################

#Define cyg-conda and cyg-activate to facilitate management of conda.

alias cyg-conda=${CONDA_BASE_DIR}/Scripts/conda.exe

cyg-activate() {
    export CONDA_DEFAULT_ENV=$1
    #source ~/.bash_profile
    source ~/anaconda4cygwin.bash_profile
    cyg-conda info --envs
}

###############################################################################

#  PATH - ALl of the anaconda/miniconda path entries appear first.
export PATH=$(tr -s ' \n' ':' <<eot
$CONDA_PREFIX
$CONDA_PREFIX/Library/mingw-w64/bin
$CONDA_PREFIX/Library/usr/bin
$CONDA_PREFIX/Library/bin
$CONDA_PREFIX/Scripts
eot
):$PATH

###############################################################################

# Set a prompt of:(CondaEnv) user@host and current_directory
PS1='\[\e]0;\w\a\]\n'"\[\e[35m\]${CONDA_DEFAULT_ENV}:"'\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
