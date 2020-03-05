game.firstload = "true"

-- love.load = load() , love.update = update() etc...
--[[

    All images, sounds or other love2d objects, should be made in scopes
    are global. duplicate sprites will be overwritten so unique names are needed
    for other scapes

    unless, you localize the variables by following this format.

    but if you wish not to use a localized format you can use the format in
    ofupdate2.lua

]]
local ofupdate = {}
function ofupdate.load()
    spritetoscape(stll_wait)
  -- add size content
  lspr.addcontentstoshape("rectangle",{size = size});


  spritetoscape(game.stll_bg)

back = ofupdate.newbutton(460,window.new.perm.height/2+130,80,34,"back")
back.colors = {rgb(0.42,0.42,0.42),rgb(0,0,0)}

back.onrelease = function()
  setscape(loader)
end
  if gameinfo.newver == gameinfo.ver then
    setscape(loader)
    return
   else
  ofupdate.title = createsprite(50,window.new.perm.height/2+130,"text")
  ofupdate.title.font = game.gamefont
  ofupdate.title.text = "Update to the newest version!"
end


  spritetoscape(load.loadbar.back)
    spritetoscape(load.loadbar.front)
    spritetoscape(load.ltitle)




end
ofupdate.buttonlist = {}
function ofupdate.update()
  load.ltitle.text = "Update package running."
  ofupdate.dobuttons()
end

function ofupdate.draw()

end

function size(self,w,h)
  self.width = w
  self.height= h
end

function ofupdate.newbutton(x,y,w,h,text)
  -- default text
  if text == nil then text = "EMPTY" end

  -- create button object
  local button = {
    -- the x
    x = x,
    -- the y
    y = y,
    -- the width
    width = w,
    -- the height
    height = h,
    -- open
    open = true,
    -- create display sprite
    sprite = createsprite(x,y,"rectangle"),
    -- create button text
    text = createsprite(x,y,"textf"),
    -- bool if pressed
    lastpressed = false,
    pressed = false,
    --
    released = false,
    onrelease = function()end,
    onupdate = function()end,

    colors = {rgb(1,1,1),rgb(0,0,0)},
    font = game.gamefont,
    --
    pauseall = false,
    pause = false,
    align = left
  }

  -- manage button after creating
  -- set first state
  button.sprite.color = button.colors[1]
  -- auto size for limit

  button.sprite.width = w
  button.sprite.height = h
  button.width = button.sprite.width
  button.height = button.sprite.height
  -- set  fonts
  button.text.font = button.font
  -- set  limit
  button.text.limit = button.sprite.width
  -- set  text
  button.text.text = text
  button.text.align = left



  button.x = button.text.x

  -- set visibility  for both sprites
  button.setvisiblity = function(self,bool)
    self.sprite.visible = bool
    self.text.visible = bool
  end
  button.state  = function(self,state)
    self.sprite.color = self.colors[state]
  end
  -- run
  button.update = function(self,x,y,pressed)
    if self.pauseall then return end
    self:onupdate()
    if self.pause then return end

    -- update values
    self.text.align = self.align

    self.text.font = self.font

    self.sprite.x = self.x
    self.sprite.y = self.y
    self.text.x = self.x
    self.text.y = self.y

    -- now check for open
    if self.open then
      -- save last pressed before updating pressed
      self.lastpressed = self.pressed
      -- unpress
      self.pressed = false
      -- check pressed
      if pressed then
        -- check for touch
        if istouchpoint(self.sprite,x,y) then
        -- set press state
        self.pressed = true
        -- set open
        self.open = false
        end
        --  end istouchpoint
      end
      -- deterimine released
      self.released = (self.lastpressed and pressed == false)

      -- end pressed
    end

    -- end self.open
    -- set images based on press
    if self.pressed then
      self.sprite.color = self.colors[2]
      self.text.y  = self.y + pxllockvalue(1)
    else
      self.sprite.color = self.colors[1]
      self.text.y =   self.y
      self.text.x =   self.x
      self.sprite.x = self.x
      self.sprite.y = self.y
      self.sprite.width = self.width
      self.sprite.height = self.height
    end

    if self.released then
      self:onrelease()
    end

  end
  -- button close for reseting after running update multiple times
  button.close = function(self)
    -- reopen
    self.open = true
  end
  ofupdate.buttonlist[#ofupdate.buttonlist+1] = button
  return button

end
function ofupdate.dobuttons()
  -- short love.mouse to lm
  lm = love.mouse
  -- getting values for mouseimplemntation
  mousex , mousey , mousepressed = nwx(lm.getX())  , nwy(lm.getY()) , lm.isDown(1)
  for i=1,#ofupdate.buttonlist do
    ofupdate.buttonlist[i]:update(mousex,mousey,mousepressed)
    ofupdate.buttonlist[i]:close()
    -- body...
  end

  -- update buttons
end

-- Make sure this is accurate
-- if not it will not work correctly you must return load,draw,update
-- functions even if there empty.
return {load = ofupdate.load,update = ofupdate.update,draw = ofupdate.draw,}
