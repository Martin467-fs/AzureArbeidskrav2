import re
import os.path
import os
from sys import exit

def getLengthOfLongestStringInList(yourList):
    longest = 0
    for s in yourList:
        if len(s) > longest:
            longest = len(s)
    return longest
    

try:
    file = open("variables.tf", "r")
except:
    print("variables.tf doesn't exist")

    exit()
variableList = []
defaultList = []
for lines in file:
    if "variable" in lines:
        # regex "(.*?)" captures anything between two quotes
        match = re.search("\"(.*?)\"", lines)
        if match == None:
            continue
        r = match.group()
        r = r.replace("\"", "")
        variableList.append(r)
    if "default" in lines:
        default = lines[lines.index("="):]
        defaultList.append(default)
file.close()

if os.path.isfile("terraform.tfvars"):
    print("File: terraform.tfvars exists. Overwrite?")
    answer = input()
    if answer == "yes" or answer == "y" or answer == "yuh" or answer == "Y" or answer == "YES":
        os.remove("terraform.tfvars")
        print("terraform.tfvars overwritten.")
    else:
        print("Not touching terraform.tfvars. Exiting.")
        exit()
    
length = getLengthOfLongestStringInList(variableList)

file2 = open("terraform.tfvars", "w")
for num in range(0, len(variableList)):
    spacing = " "*(2+length - len(variableList[num]))

    file2.write(variableList[num]+spacing+defaultList[num])

file2.close()
