![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54) ![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white) ![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white) ![Shell Script](https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)


# Zappa Template

Get going fast with a new [Zappa](https://github.com/zappa/Zappa) project.


## Setup

1. Fork this repo
1. Create a new repo using this template
1. Clone the new repo
1. Run `./init.sh`
1. Run `./new-function.sh {function_name}` to create a skeleton directory for your AWS Lambda function
1. Repeat 5. for each function you need


## How does it work?

When you `./deploy.sh` one or more functions, the following steps are performed inside a Python virtual environment:
1. Top-level `requirements.txt` is installed
1. If it doesn't exist yet, a Lambda Layer is built using Docker and uploaded to AWS
 * It's version is exported as an Environment Variable
1. Environment Variables named `{UPPER_REPO_NAME}_{UPPER_FUNCTION_NAME}_{VAR_NAME}` are exported as `{VAR_NAME}` for use in the next step
1. A Zappa template is generated using `zappa_template.json` inside the function directory, replacing any configured environment variables
1. `Zappa Deploy` or `Zappa Update` is run, as appropriate


## Function Structure

| File                  | Use
| --------------------: | :----------------------------------------------------------------------------------------
| `log.py`              | Can be used to log various levels of output
|                       | `from log import log`
|                       | `log.info("message")` or `log.error("message")` etc.
| `main.py`             | The entry point of the Lambda function
| `requirements.txt`    | Used when executing a function locally or building a Lambda Layer during deploy
| `utils.py`            | Utility functions that can be used
| `zappa_template.json` | Tells Zappa how to deploy a Lambda function
|                       | See `zappa_template_options.json` for available properties
|                       | Environment Variables can be used for deploy-time replacement of values


## Executables

| File                                          | Use
| --------------------------------------------: | :----------------------------------------------------------------------------------------
| `./init.sh`                                   | Setup the main Python virtual environment, plus specific ones for each existing function
| `./new-function.sh {function_name}`           | Create a skeleton directory for a new Lambda function
| `./deploy.sh [function_name]`                 | Deploy one or all Lambda functions
| `./status.sh [function_name]`                 | Check the deployment status of one or all Lambda functions
| `./undeploy.sh [function_name]`               | Undeploy one or all Lambda functions
| `./scripts/exec_function.sh {function_name}`  | Execute a function locally
|                                               | Run inside the function-specific Python virtual environment
|                                               | `functions/{function}/requirements.txt` is installed
|                                               | Environment Variables named `{UPPER_REPO_NAME}_{UPPER_FUNCTION_NAME}_{VAR_NAME}` are exported as `{VAR_NAME}` for use by the function


## Environment Variables

| Required              | Optional
| :-------------------- | :----------------------------------------------------------------------------------------
| AWS_ACCESS_KEY_ID     | AWS_REGION
| AWS_SECRET_ACCESS_KEY | {UPPER_REPO_NAME}\_{UPPER_FUNCTION_NAME}\_{VAR_NAME}


## Github Action

A `deploy.yml` Github Action is provided to enable deployment remotely (CD) after operations such as Push and Merge. Customise as required.

The Environment Variables mentioned above will need to be available in Github Secrets, include GH_TOKEN to enable the repo to be checked out.

Individual commits of Github Action libraries are specified instead of Versions to avoid malicious updates being "injected" into the Action executions.


## Stuff to note

An example file `zappa_template_options.json` is included to demonstrate available properties in a Zappa template.

Some functions are ignored when deploying:
* `example`
* Where `requirements.txt` is missing from the function directory
* Where `main.py` is missing from the function directory


## Future Improvements

* allow other AWS credential providers to be used
* provide some common function examples for even faster development
* provide an example RESTful API with easy Authentication and Authorisation integration
