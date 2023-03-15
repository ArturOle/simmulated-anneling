using DataFrames
using CSV
using Test

function mean(orginal_data, args)
    len = length(original_data[:,1])
    variables = zeros(length(original_data[:,1]))

    varialbes .= (original_data[:, 2] .- arguments[1] * (original_data[:, 1].^2 - arguments[2] .* cos(arguments[3] * pi * original_data[:, 1]))).^2
    return sum!(variables)/len
end


data_frame = CSV.read("data/model1.txt", DataFrame, delim=" ")[:, 2:3]
args = [ 0.0 0.5 0.75 ]

variables = zeros(length(data_frame[:,1]))
variables .= (data_frame[:, 2] .- args[1] * (data_frame[:, 1].^2 - args[2] .* cos.(args[3] * pi * data_frame[:, 1]))).^2

f_0 = zeros(length(data_frame[:,1]))
@time for i in 1:101
    f_0[i] = (data_frame[i, 2] - args[1] * (data_frame[i, 1]^2 - args[2] * cos(args[3] * pi * data_frame[i, 1])))^2
end

# @test variables == f_0
# # mean(data_frame, args)

variables = zeros(length(data_frame[:,1]))
@time variables .= (data_frame[:, 2] .- args[1] * (data_frame[:, 1].^2 - args[2] .* cos.(args[3] * pi * data_frame[:, 1]))).^2
