BeginPlayState = Class{__includes = BaseState}

function BeginPlayState:enter(params)
    self.level = params.level
end

function BeginPlayState:init()
    self.volume = 0
    self.timer = 0
    MUSIC = false
    gSounds['ice-foot']:play()
    gSounds['ice-foot']:setVolume(self.volume)
end

function BeginPlayState:update(dt)
    self.timer = self.timer + dt
    for i = 0, 10 do
        if self.timer > i / 10 then
            self.volume = i * 10
        end
    end

    if not gSounds['ice-foot']:isPlaying() then
        gStateMachine:change('play')
        MUSIC = true
    end
end

