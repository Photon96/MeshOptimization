function [alfa] = ArmijoSearch(xk, fx, grad, p, beta, tau, function_handle)
    alfa = 1;
    while function_handle(xk + alfa*p) > fx + alfa*beta*grad'*p
        alfa = alfa * tau;
    end
end
