class_name Jacobian

static func dAda(_a, b, c, xi, _yi):
	return -exp(2*b*xi+2*c*xi*xi);
static func dAdb(a, b, c, xi, yi):
	return xi*yi*ut_exp(b, c, xi) + 2*a*xi*dAda(a, b, c, xi, yi);
static func dAdc(a, b, c, xi, yi):
	return xi*xi*yi*ut_exp(b, c, xi) + 2*a*xi*xi*dAda(a, b, c, xi, yi);
static func dBda(a, b, c, xi, yi):
	return dAdb(a, b, c, xi, yi);
static func dBdb(a, b, c, xi, yi):
	return a*xi*xi*yi*ut_exp(b, c, xi) + 2*a*a*xi*xi*dAda(a, b, c, xi, yi);
static func dBdc(a, b, c, xi, yi):
	return a*pow(xi, 3)*yi*ut_exp(b, c, xi) + 2*a*a*pow(xi, 3)*dAda(a, b, c, xi, yi);
static func dCda(a, b, c, xi, yi):
	return pow(xi, 2)*yi*ut_exp(b, c, xi) + 2*a*xi*xi*dAda(a, b, c, xi, yi);
static func dCdb(a, b, c, xi, yi):
	return a*pow(xi, 3)*yi*ut_exp(b, c, xi) + 2*a*a*pow(xi, 3)*dAda(a, b, c, xi, yi);
static func dCdc(a, b, c, xi, yi):
	return a*pow(xi, 4)*yi*ut_exp(b, c, xi) + 2*a*a*pow(xi, 4)*dAda(a, b, c, xi, yi);
# e^(bx+cx^2)
static func ut_exp(b, c, xi):
	return exp(b*xi+c*xi*xi);

static func calculate_jacobian(a, b, c, x, y):
	var jacobian = Utility.create_2d_array(3, 3, 0);
	for i in x.size():
		jacobian[0][0] += dAda(a, b, c, x[i], y[i])
		jacobian[0][1] += dAdb(a, b, c, x[i], y[i])
		jacobian[0][2] += dAdc(a, b, c, x[i], y[i])
		jacobian[1][0] += dBda(a, b, c, x[i], y[i])
		jacobian[1][1] += dBdb(a, b, c, x[i], y[i])
		jacobian[1][2] += dBdc(a, b, c, x[i], y[i])
		jacobian[2][0] += dCda(a, b, c, x[i], y[i])
		jacobian[2][1] += dCdb(a, b, c, x[i], y[i])
		jacobian[2][2] += dCdc(a, b, c, x[i], y[i])
	
	for i in range(jacobian.size()):
		for j in range(jacobian.size()):
			jacobian[i][j] *= 2.0;
	
	return jacobian;
