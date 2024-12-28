function lr=cal_lr(lr,judge1_old,judge1)
    if judge1>=judge1_old
        lr=lr/2;
    else lr=lr;
    end