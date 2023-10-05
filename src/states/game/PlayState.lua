PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.camX = 0
    self.camY = 0
    self.background = math.random(3)
    self.backgroundX = 0

    self.gravityOn = true
    self.gravityAmount = 6
end