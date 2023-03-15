
include("schedules.jl")
using Random
using CSV
using DataFrames
using Plots
using Distributions


function mean(original_data, args)
    len = length(original_data[:,1])
    variables = zeros(length(original_data[:,1]))
    variables .= (original_data[:, 2] .- args[1] * (original_data[:, 1].^2 - args[2] .* cos.(args[3] * pi * original_data[:, 1]))).^2
    return sum(variables)/len
end

function SimulatedAnneling(filename::String)
    data_frame = CSV.read(filename, DataFrame, delim=" ")[:, 2:3]
    alpha = 0.99999
    beta = 0.0001
    T_0 = 10^6
    epsilon = 10^(-3)
    iter = 0
    T = [T_0 T_0 T_0]
    X_0 = rand(-10.0:00.1:10.0, 3)
    f_x = 0.0
    f_x_last = 1.0

    while !(abs(f_x_last - f_x) < epsilon)
        f_0 = 0.0
        for i in 1:101
            f_0 = f_0 + (data_frame[i, 2] - X_0[1] * (data_frame[i, 1]^2 - X_0[2] * cos(X_0[3] * pi * data_frame[i, 1])))^2
        end
        f_0 = f_0/101

        X_i = [0.0 0.0 0.0]
        for i in 1:3
            X_i[i] = X_0[i] + rand(Normal(0, T[i])) # rand(0:0.01:T[i]) 
        end

        f_x_last = f_x
        for i in 1:101
            f_x = f_x + (data_frame[i, 2] - X_i[1] * (data_frame[i, 1]^2 - X_i[2] * cos(X_i[3] * pi * data_frame[i, 1])))^2
        end
        f_x = f_x/101



        if f_0 > f_x
            X_0 = X_i
            display(X_0)
        else 
            for i in 1:3
                r = rand(0:0.001:1)
                
                if r < exp((f_0 - f_x) / T[i])
                    X_0[i] = X_i[i]
                    display(X_0)
                end
            end
        end
        T = T .* alpha
        iter += 1

    end

    results = zeros((1,101))
    for i=1:101
        results[i] = X_0[1] * (data_frame[i, 1]^2 - X_0[2] * cos(X_0[3] * pi * data_frame[i, 1]))
    end
    # display(results)
    # display(iter)
    scatter(data_frame[:, 1], data_frame[:, 2], color=:blue)
    scatter!(data_frame[:, 1], results[:], color=:red)
end

function optimized_function(original_data, arguments, index)
    return (original_data[index, 2] - arguments[1] * (original_data[index, 1]^2 - arguments[2] * cos(arguments[3] * pi * original_data[i, 1])))^2
end

function increase!(variable, math_function, args, original_data, index)
    variable = variable + math_function(original_data, args, index)
end


function SimulatedAnnelingOpt(filename::String)
    data_frame::DataFrame = CSV.read(filename, DataFrame, delim=" ")[:, 2:3]
    alpha::Float16 = 0.99999
    beta::Float16 = 0.0001
    T_0::Float64 = 10^6
    epsilon::Float32 = 10^(-3)
    iter::Int32 = 0
    T::Matrix{Float64} = [T_0 T_0 T_0]
    X_0 = rand(-10.0:00.1:10.0, 3)
    typeof(X_0)
    f_x::Float64 = 0.0
    f_x_last::Float64 = 1.0

    while abs(f_x_last - f_x) >= epsilon
        # f_0 = 0.0
        # for i in 1:101
        #     f_0 = f_0 + (data_frame[i, 2] - X_0[1] * (data_frame[i, 1]^2 - X_0[2] * cos(X_0[3] * pi * data_frame[i, 1])))^2
        # end
        # f_0 = f_0/101
        f_0 = mean(data_frame, X_0)

        X_i = [0.0 0.0 0.0]
        for i in 1:lenght(X_i)
            X_i[i] = X_0[i] + rand(Normal(0, T[i])) # rand(0:0.01:T[i]) 
        end
        f_x_last = f_x
        f_x = mean(data_frame, X_i)

        if f_0 > f_x
            X_0 = X_i
            display(X_0)
        else 
            for i in 1:3
                r = rand(0:0.001:1)
                
                if r < exp((f_0 - f_x) / T[i])
                    X_0[i] = X_i[i]
                    display(X_0)
                end
            end
        end
        T = T .* alpha
        iter += 1
    end

    results = zeros((1,101))
    for i=1:101
        results[i] = X_0[1] * (data_frame[i, 1]^2 - X_0[2] * cos(X_0[3] * pi * data_frame[i, 1]))
    end
    # display(results)
    # display(iter)
    scatter(data_frame[:, 1], data_frame[:, 2], color=:blue)
    scatter!(data_frame[:, 1], results[:], color=:red)
end

# @time SimulatedAnneling("data/model1.txt")
@time SimulatedAnnelingOpt("data/model1.txt")
