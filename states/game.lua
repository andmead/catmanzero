function Game()
    return {
        state = {
            menu = true,
            running = false,
            ended = false
        },

        changeGameState = function (self, state)
            self.state.menu = state == 'menu'
            self.state.running = state == 'running'
            self.state.ended = state == 'ended'
        end
    }
end

return Game