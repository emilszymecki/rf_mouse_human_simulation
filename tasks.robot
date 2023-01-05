*** Settings ***
Documentation       Playwright template.

Library             Browser    jsextension=${CURDIR}/module.js
Library             lib/lib.py
Library             RPA.Desktop
Library             Collections


*** Tasks ***
Minimal task
    Starting a browser    https://robocorp.com/docs
    Click as Human Single    \#__next > main > div > aside > nav > a:nth-child(10)
    Click as Human Single    h6 >> text=RPA.Browser.Playwright
    Click as Human Multi    .ps--active-y a



*** Keywords ***
Starting a browser
    [Arguments]    ${url}
    New Browser    chromium    headless=false    args=["--start-maximized"]
    Set Browser Timeout    30s
    New Context    viewport=${None}
    New Page    ${url}

    
Click as Human Multi
    [Arguments]    ${locator}
    ${elements}=    Get Elements    ${locator}
    FOR    ${element}    IN    @{elements}[:10]
        Log    ${element}
        Click as Human Single    ${element}
    END


Click as Human Single
    [Arguments]    ${locator}
    ${element}=    Get Element    ${locator}
    ${cssPath}=    Get Path from Get Element Keyword Playwright    ${element}
    Wait For Elements State    ${element}    visible    timeout=10s
    ${mousePosition}=    Get mouse position
    Log    Current mouse position is ${mousePosition.x}, ${mousePosition.y}
    &{windowParameters}=    GetCoordCenter    ${cssPath}
    ${move_list}=    genMoveMouseSteps    ${mousePosition.x}    ${mousePosition.y}    ${windowParameters.x}    ${windowParameters.y}    ${2}
    FOR    ${move}    IN    @{move_list}
        Log    ${move}
        ${mouse}=    Get mouse position
        Log    Current mouse position is ${mouse.x}, ${mouse.y}
        Move mouse    point:${move}[0],${move}[1]
    END
    Sleep    1s
    RPA.Desktop.Click

Get Path from Get Element Keyword Playwright
    [Arguments]    ${element}
    ${cssPath}=    Evaluate JavaScript    ${element}
     ...    (element, arg) => {
     ...        var cssPath = function(el) {
     ...           if (!(el instanceof Element)) 
     ...               return;
     ...           var path = [];
     ...           while (el.nodeType === Node.ELEMENT_NODE) {
     ...               var selector = el.nodeName.toLowerCase();
     ...               if (el.id) {
     ...                   selector = "\#" + el.id;
     #add \ before hash
     ...                   path.unshift(selector);
     ...                   break;
     ...               } else {
     ...                   var sib = el, nth = 1;
     ...                   while (sib = sib.previousElementSibling) {
     ...                       if (sib.nodeName.toLowerCase() == selector)
     ...                          nth++;
     ...                   }
     ...                   if (nth != 1)
     ...                       selector += ":nth-of-type("+nth+")";
     ...               }
     ...               path.unshift(selector);
     ...               el = el.parentNode;
     ...           }
     ...           return path.join(" > ");
     ...        }
     ...        return cssPath(element)
     ...    }
     ...    all_elements=False
     ...    arg=Just another Text
    [Return]    ${cssPath}