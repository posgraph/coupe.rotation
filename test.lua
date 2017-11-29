require 'xlua'
require 'optim'
require 'cunn'
require 'nn'
require 'cudnn'
require 'image'
require 'stn'
cudnn.benchmark = true
cudnn.fastest = true


img = image.load('316_0.jpg', 3)
--img = image.load('ee13.jpg', 3, 'float')
img_bak = img:clone()
minsz = math.min(img:size()[2], img:size()[3])
img = image.crop(img, 'c', minsz, minsz)
img = image.scale(img, 224, 224)
batch = img:view(1, table.unpack(img:size():totable()))
--img = {image.scale(img, 56, 56), image.scale(img, 112, 112), image.scale(img, 224, 224)}

predict_net = torch.load('16_net_D_A.t7'):cuda()
--score_net = torch.load('./average_score_net.t7')
predict_net:evaluate()

crit = nn.AbsCriterion()
crit:cuda()

predicted_angle = predict_net:forward(batch:cuda())
real_angle = predicted_angle[1][1]-20
print('angle : '.. real_angle)

-- rotation_params = torch.FloatTensor(1,1):fill(math.rad(real_angle))
-- rotation_params = rotation_params:cuda()

-- -- -- grid generator + sampler (rotation operator)
-- rotation_net = nill
-- tranet = nn.Sequential()
-- tranet:add(nn.Identity())
-- tranet:add(nn.Transpose({2,3},{3,4}))

-- paranet = nn.ParallelTable()
-- paranet:add(tranet)

-- gridnet = nn.Sequential()
-- gridnet:add(nn.AffineTransformMatrixGenerator(true, false, false))
-- gridnet:add(nn.AffineGridGeneratorBHWD(224, 224))

-- paranet:add(gridnet)

-- rotation_net = nn.Sequential()
-- rotation_net:add(paranet)
-- rotation_net:add(nn.BilinearSamplerBHWD())

-- rotation_net:add(nn.Transpose({3,4},{2,3}))
-- rotation_net:cuda()



-- rotation_net_input = {batch:cuda(), rotation_params}
-- img_rotated = rotation_net:forward(rotation_net_input)
-- output_img = img_rotated[1]
-- image.save('rotated.jpg', output_img)






-- using imrotate
img_rotated = image.rotate(img_bak, (-real_angle) * math.pi/180)
image.save('rotated.jpg', img_rotated)

