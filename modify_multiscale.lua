require 'nn'
require 'cunn'
require 'cudnn'

net = torch.load('10_net_D_A.t7')
net:remove()
net:remove()
net:remove()
net:remove()
net:remove()
net:remove()
-- net:remove()

connet = nn.ConcatTable()
connet:add(nn.SpatialAdaptiveAveragePooling(1,1))
connet:add(nn.SpatialAdaptiveAveragePooling(2,2))

viewnet = nn.ParallelTable()
viewnet:add(nn.View(-1):setNumInputDims(3))
viewnet:add(nn.View(-1):setNumInputDims(3))

fcnet = nn.ParallelTable()
fcnet:add(nn.Linear(512, 256))
fcnet:add(nn.Linear(2048, 256))

net:add(connet)
net:add(viewnet)
net:add(fcnet)

net:add(nn.MapTable():add(nn.Sequential():add(nn.ReLU()):add(nn.Dropout(0.5))))

net:add(nn.JoinTable(2))
net:add(nn.Linear(512, 1))

net:cuda()
