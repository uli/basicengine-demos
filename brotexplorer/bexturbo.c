int iterbrot(double x0, double y0, double x, double y, int maxiteration)
{
    int iteration = 0;
    double xtemp;
    while (x*x + y*y <= 4 && iteration < maxiteration) {
        xtemp = x*x - y*y + x0;
        y = 2 * x * y + y0;
        x = xtemp;
        ++iteration;
    }
    if (iteration >= maxiteration)
        return 0;
    else
        return iteration;
}
