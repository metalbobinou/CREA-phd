import sys
import os

from MyTools import *
from MyPDFixInterface import *


def main():
#    for arg in sys.argv:
#        print(arg)
    email = Utils.getEmail()                # email address
    licenseKey = Utils.getLicenseKey()      # license key
    email = "fabrice.metalman2@wanadoo.fr"
    licenseKey = "2C8jhHNxpMNiT3CV4"

    Files = [
        "C1-Cours HTML-PHP - Coquery.pdf",
        "C8-Gestion-Web-PHP-Manuele (M1).pdf"
        ]
#    try:
    cwd = os.getcwd() + "/"                 # current working directory
    if not os.path.isdir(cwd + 'output'):
        os.makedirs(cwd + 'output')
        # pdfix initialization
    Pdfix_init(cwd + Utils.getModuleName('pdfix'))

    for FileName in Files:
        print("-- " + FileName)
        OutName = changeExtension(FileName, "txt")
            # ExtractText(email, licenseKey,
        ExtractTextWithoutHeaderFooter(email, licenseKey,
                                       cwd + 'input/' + FileName,
                                       cwd + 'output/' + OutName,
                                       cwd + 'resources/config.json')

    Pdfix_destroy()
#    except Exception as e:
#        print('Oops! ' + str(e))


main()
