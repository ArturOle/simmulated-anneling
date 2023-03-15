
exponential(alfa, T::Vector) = alfa.*T
inverse_exponential(beta, T::Vector) = T./(beta.*T.+1)

function exponential!(alfa, T::Matrix) 
    T .= alfa.*T
end

function inverse_exponential!(beta, T::Matrix) 
    T .= T./(beta.*T.+1)
end
