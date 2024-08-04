import logging
import subprocess
import os

def main(branch,lab,domain,github_user,github_personal_access_token):
    try:
        script_filename = 'run_powershell_personal.py'
        logging.info(f"------------------- {script_filename} --------------------")
        # Define the path to PowerShell 7.3.7
        ps_path = r"C:\Program Files\PowerShell\7\pwsh.exe"
        logging.info(f"\nlab : {lab}\n"
                     f"branch : {branch}\n"
                     f"domain : {domain}\n"
                     f"ps path : {ps_path}\n"
                     f"github_user : {github_user}\n"
                     f"github_personal_access_token : {github_personal_access_token}\n")
        if domain == 'RWN':
            powershell_script_path = r'_internal\personal_lab\run-personal-lab-SameDomain.ps1'
        else:
            powershell_script_path = r'_internal\personal_lab\run-personal-lab-DifferentDomain.ps1'

        # Get the directory of the PowerShell script
        script_directory = os.path.dirname(powershell_script_path)
        # Change the working directory to the script's directory
        os.chdir(script_directory)
        powershell_script_path = powershell_script_path.split("\\")[2]
        branch_name = branch
        personal_lab_name = 'labs-'+lab.split('_')[1]+'.ps1'



        # Construct the command to run the PowerShell script with arguments
        command = [ps_path, powershell_script_path,
                   '-GitHubUser', github_user,
                   '-GitHubUserPersonalAccessToken', github_personal_access_token,
                   '-BranchName', branch_name,
                   '-PersonalLabName', personal_lab_name]
        logging.info(f"ps command : {command}\n")
        # Run the PowerShell script
        process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        # Wait for the process to complete and capture the stdout
        stdout, stderr = process.communicate()
        # Decode the stdout bytes to a string
        stdout_str = stdout.decode('utf-8')

        #Split the string by newlines to get individual values
        returned_values = stdout_str.strip().split('\n')
        #take the last two
        if len(returned_values) >= 2:
            globalDeploymentLogFile = returned_values[-2]
            globalOutputTrxFolder = returned_values[-1]
        globalOutputTrxFolder = globalOutputTrxFolder.replace('\202', '\\202')
        logging.info(f"log file : {globalDeploymentLogFile}\n"
                     f"trx folder : {globalOutputTrxFolder}\n")

        # Check the return code to see if the script was successful (0 indicates success)
        if process.returncode == 0:
            logging.info("PowerShell script executed successfully")
            print("PowerShell script executed successfully")
            return [0,globalDeploymentLogFile, globalOutputTrxFolder]
        else:
            logging.info("PowerShell script encountered an error")
            print("PowerShell script encountered an error")
            return [1,"run ps script error"]

    except Exception as e:
        error_message = f"An error occurred: {str(e)}"
        logging.error(error_message)
if __name__ == '__main__':
    main()