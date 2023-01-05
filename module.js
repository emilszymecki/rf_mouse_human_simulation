async function GetCoord(arg, page) {
    return await page.evaluate(arg => {
            const position = document.querySelector(arg).getBoundingClientRect();
            const x = position.left;
            const y = position.top;
        
            const XLoc = window.screenX;
            const YLoc = window.screenY;
            const toolbarHeight = window.outerHeight - window.innerHeight;
            return ({x:x + XLoc,y:y + YLoc + toolbarHeight})
    }, arg);
  }


  async function GetCoordCenter(arg, page) {
        return await page.evaluate(arg => {
          const element = document.querySelector(arg);
          const position = element.getBoundingClientRect();
          const x = position.left + (position.width / 2);
          const y = position.top + (position.height / 2);

      
          const XLoc = window.screenX;
          const YLoc = window.screenY;
          const toolbarHeight = window.outerHeight - window.innerHeight;
          return ({ x: x + XLoc, y: y + YLoc + toolbarHeight });
        }, arg);
}

  exports.__esModule = true;
  exports.GetCoord = GetCoord;
  exports.GetCoordCenter = GetCoordCenter;