local pushingText = {}
local pushingText_mt = {__index = pushingText}



function pushingText.new(theText,positionX,positionY,theFont,theFontSize,theGroup)
	  local theTextField = display.newText(theText,positionX,positionY,theFont,theFontSize)	  local newPushingText = {
                                                  theTextField = theTextField}     theGroup:insert(theTextField)                                             
	return setmetatable(newPushingText,pushingText_mt)
end

function pushingText:setColor(r,b,g)
  self.theTextField:setFillColor(r,g,b)
end

function pushingText:Pushtext()
	transition.to( self.theTextField, { xScale=2.0, yScale=2.0, time=4000, iterations = 1} )
end

return pushingText