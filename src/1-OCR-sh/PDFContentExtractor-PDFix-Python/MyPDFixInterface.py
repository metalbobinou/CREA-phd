import Utils
from Pdfix import *


def GetText (element, output):
    elemType = element.GetType()
    if kPdeText == elemType:
        textElem = PdeText(element.obj)
        text = textElem.GetText()
        output.write(text)
        output.write("\n")
    else:
        count = element.GetNumChildren()
        if count == 0:
            return
        for i in range(0, count):
            child = element.GetChild(i)
            if child is not None:
                GetText(child, output)


def ExtractText(email, key,
    open_path,                     # PDF document to open
    save_path,                     # output txt document
    config_path):                  # path to configuration file

    pdfix  = GetPdfix()
    if pdfix is None:
        raise Exception('Pdfix Initialization fail')
    # authorization
    if not pdfix.Authorize(email, key):
        raise Exception('Authorization fail : ' + str(pdfix.GetError()))

    doc = pdfix.OpenDoc(open_path, "")
    if doc is None:
        raise Exception('Unable to open doc : ' + str(pdfix.GetError()))

    # prepare the output file
    output = open(save_path, "w")
    numPages = doc.GetNumPages()
    for i in range(0, numPages):
        # acquire page
        page = doc.AcquirePage(i)
        if page is None:
            raise Exception('Acquire Page fail : ' + str(pdfix.GetError()))
        # get the page map of the current page
        pageMap = page.AcquirePageMap(0, None)
        if pageMap is None:
            raise Exception('Acquire PageMap fail : ' + str(pdfix.GetError()))
        # get page container
        container = pageMap.GetElement()
        if container is None:
            raise Exception('Get page element failure : ' + str(pdfix.GetError()))
        GetText(container, output)

    output.close()

    doc.Close()
    pdfix.Destroy()




def ExtractTextWithoutHeaderFooter(email, key,
    open_path,                     # PDF document to open
    save_path,                     # output txt document
    config_path):                  # path to configuration file

    pdfix  = GetPdfix()
    if pdfix is None:
        raise Exception('Pdfix Initialization fail')
    # authorization
    if not pdfix.Authorize(email, key):
        raise Exception('Authorization fail : ' + str(pdfix.GetError()))

    doc = pdfix.OpenDoc(open_path, "")
    if doc is None:
        raise Exception('Unable to open doc : ' + str(pdfix.GetError()))

    # prepare the output file
    output = open(save_path, "w")
    numPages = doc.GetNumPages()
    for i in range(0, numPages):
        # acquire page
        page = doc.AcquirePage(i)
        if page is None:
            raise Exception('Acquire Page fail : ' + str(pdfix.GetError()))

        # get the page map of the current page
        pageMap = page.AcquirePageMap(0, None)
        if pageMap is None:
            raise Exception('Acquire PageMap fail : ' + str(pdfix.GetError()))

        # get page container
        container = pageMap.GetElement()
        if container is None:
            raise Exception('Get page element failure : ' + str(pdfix.GetError()))
        # get container cell
        maxChilds = container.GetNumChildren()
        #pdeheader = PdeHeader()
        #pdefooter = PdeFooter()
        for numChild in range(maxChilds):
            child = container.GetChild(numChild)
            childType = child.GetType()
            # PdfElementType.kPdeImage = 5
            # PdfElementType.kPdeLine = 6
            # PdfElementType.kPdeRect = 9
            # PdfElementType.kPdeTable = 5

            # PdfElementType.kPdeHeader = 14
            # PdfElementType.kPdeFooter = 15
            print(childType)
            if ((childType != 14) and (childType != 15)):
                GetText(child, output)

        # Copy the text into the output file
        #GetText(container, output)
        #GetText(cell, output)

    output.close()

    doc.Close()
    pdfix.Destroy()
