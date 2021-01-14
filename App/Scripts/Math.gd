class_name Math


static func calculateLU(matrix : Array) -> Array:
	var n = matrix.size()
	var lower = Utility.create_2d_array(n, n, 0)
	var upper = Utility.create_2d_array(n, n, 0)
	for i in n: 
		# U
		for k in range(i, n):
			# Summation of L(i, j) * U(j, k)
			var sum = 0;
			for j in range(i):
				sum += (lower[i][j] * upper[j][k]);
			# Evaluating U(i, k)
			upper[i][k] = matrix[i][k] - sum;
		# L
		for k in range(i, n):
			if (i == k):
				lower[i][i] = 1; # Diagonal as 1
			else:
				# Summation of L(k, j) * U(j, i)
				var sum = 0;
				for j in range(i):
					sum += (lower[k][j] * upper[j][i])
				# Evaluating L(k, i)
				lower[k][i] = (matrix[k][i] - sum) / upper[i][i];
	return [lower, upper]

# calculate LU using Cholesky-Banachiewicz and Cholesky–Crout algorithm
static func calculateLLT(matrix : Array) -> Array:
	var n = matrix.size()
	var lower = Utility.create_2d_array(n, n, 0)
	var upper = Utility.create_2d_array(n, n, 0)
	
	lower[0][0] = sqrt(matrix[0][0])
	upper[0][0] = lower[0][0]
	
	lower[1][0] = matrix[1][0]/lower[0][0]
	lower[2][0] = matrix[2][0]/lower[0][0]
	upper[0][1] = lower[1][0]
	upper[0][2] = lower[2][0]
	
	lower[1][1] = sqrt(matrix[1][1] - pow(lower[1][0], 2))
	upper[1][1] = lower[1][1]
	
	lower[2][1] = (matrix[2][1] - lower[2][0]*lower[1][0])/lower[1][1]
	upper[1][2] = lower[2][1]
	
	lower[2][2] = sqrt(matrix[2][2] - pow(lower[2][0], 2) - pow(lower[2][1], 2))
	upper[2][2] = lower[2][2]
	
	return [lower, upper]

static func calculateX_using_LLT(lu, b):
	var lu_size = lu[0].size()
	# find y'
	var l = lu[0]
	var y = []
	y.resize(lu_size)
	for i in range(lu_size):
		y[i] = (b[0][i] - sum_of_subarray(0, i, l[i], y)) / (l[i][i]);
	
	# find x
	var u = lu[1]
	var x = []
	x.resize(lu_size)
	for i in range(lu_size):
		x[lu_size - i - 1] = (y[lu_size - i - 1] - sum_of_subarray((lu_size - i - 1) + 1, lu_size - 1, u[lu_size - i - 1], x)) / (u[lu_size - i - 1][lu_size - i - 1]);
		
	return x;

static func calculateX_using_Gaussian(a, b):
	var mat = Utility.create_2d_array(4, 3, 0)
	var res = [0, 0, 0]
	var n = a.size();
	for i in n:
		for j in n:
			mat[i][j] = a[i][j]
		mat[i][n] = b[0][i]

	for i in n:
		for j in range(i+1, n):
			if(abs(mat[i][i]) < abs(mat[j][i])):
				for k in range(n+1):
					# swapping mat[i][k] and mat[j][k]
					mat[i][k]=mat[i][k]+mat[j][k];
					mat[j][k]=mat[i][k]-mat[j][k];
					mat[i][k]=mat[i][k]-mat[j][k];
   
	# performing Gaussian elimination
	for i in range(n-1):
		for j in range(i+1, n):
			var f = mat[j][i]/mat[i][i];
			for k in range(n+1):
				mat[j][k]=mat[j][k]-f*mat[i][k];
				
	# Backward substitution for discovering values of unknowns
	for i in range(n-1, -1, -1):
		res[i]=mat[i][n];
		
		for j in range(i+1, n):
			if(i!=j):
				res[i]=res[i]-mat[i][j]*res[j];
		res[i]=res[i]/mat[i][i];  
	return res;

static func sum_of_subarray(from : int, to : int, array : Array, x : Array):
	var sum = 0;
	for i in range(from, to):
		sum += array[i]*x[i];
	return sum;

static func calculate_approximation_plot_data_parameters(x : Array, y : Array, approximation : bool) -> Array:
	var matrix = build_matrix(x, y, approximation)
	print("A=" + String(matrix[0]))
	print("B=" + String(matrix[1]))
	
	var abc = calculateX_using_Gaussian(matrix[0], matrix[1])
	if (!approximation):
		abc[0] = exp(abc[0])
	print("ABC=" + String(abc))
	return abc;

static func build_matrix(x, y, approximation : bool):
	var a = Utility.create_2d_array(3, 3, 0)
	var b = Utility.create_2d_array(3, 1, 0)
	# A x X = B
	# (n			sum(x_i)	sum(x_i^2) )	(a'	)	(sum(y_i)		)
	# (sum(x_i)		sum(x_i^2)	sum(x_i^3) ) x	(b	) = (sum(y_i*x_i)	)
	# (sum(x_i^2)	sum(x_i^3)	sum(x_i^4) )	(c	)	(sum(y_i*x_i^2)	)
	
	if (approximation):
		a[0][0] = y.size()
		for i in y.size():
			a[0][1] += x[i];
			a[0][2] += pow(x[i], 2)

			a[1][2] += pow(x[i], 3)

			a[2][2] += pow(x[i], 4)

			b[0][0] += (y[i])
			b[0][1] += (y[i])*x[i]
			b[0][2] += (y[i])*pow(x[i], 2)

		a[1][0] = a[0][1]
		a[1][1] = a[0][2]
		a[2][0] = a[1][1]
		a[2][1] = a[1][2]
	else:
		# https://mathworld.wolfram.com/LeastSquaresFittingExponential.html
		for i in y.size():
			a[0][0] += y[i]
			a[0][1] += y[i]*x[i];
			a[0][2] += y[i]*pow(x[i], 2)

			a[1][2] += y[i]*pow(x[i], 3)

			a[2][2] += y[i]*pow(x[i], 4)

			b[0][0] += y[i]*log(y[i])
			b[0][1] += y[i]*log(y[i])*x[i]
			b[0][2] += y[i]*log(y[i])*pow(x[i], 2)

		a[1][0] = a[0][1]
		a[1][1] = a[0][2]
		a[2][0] = a[1][1]
		a[2][1] = a[1][2]
	
	return [a, b]

# -----
static func generate_data_plot_data(start_x : float, end_x : float, points : int):
	var intervals = points - 1
	var x = [];
	var y = [];
	x.resize(points);
	y.resize(points)
	
	var length = end_x - start_x
	for i in range(points):
		x[i] = start_x + length*i/intervals
		# drawing of 'y' is mirrored, so we should apply minus
		y[i] = actual_function(x[i])
		
	return [x, y]

static func generate_approximation_plot_data(data_x, a, b, c) -> Array:
	var x = [];
	var y = [];
	var points = data_x.size()
	x.resize(points);
	y.resize(points)
	
	for i in range(points):
		x[i] = data_x[i]
		# drawing of 'y' is mirrored, so we should apply minus
		y[i] = approximation_function(a, b, c, x[i])
		
	return [x, y]

static func approximation_function(a, b, c, x):
	# We need to exp() approximation function,
	# to bring back non-linear view of the function.
	return a*exp(b*x + c*x*x)

static func actual_function(x):
	# Actual function, we try to approximate with
	# exponential function with three parameters.
	if (Singleton.actual_function == "cosx"):
		return cos(x)+0.01 # 3*(x)*x+2*x-5
	elif (Singleton.actual_function == "sinx"):
		return sin(x)
	elif (Singleton.actual_function == "3x^2+2x-5"):
		return 3*(x)*x+2*x-5;

static func multiple_matrix(a : Array, b : Array) -> Array:
	# (a_1 a_2 a_3)		(b_1)	(a_1 * b_1 + a_2 * b_2 + a_3 * b_3)
	# (a_4 a_5 a_6)	*	(b_2) =	(a_4 * b_1 + a_5 * b_2 + a_6 * b_3)
	# (a_7 a_8 a_9)		(b_3)	(a_7 * b_1 + a_8 * b_2 + a_9 * b_3)
	var ab = []
	ab.resize(a.size())
	
	for i in a.size():
		ab[i] = a[i][0]*b[0] + a[i][1]*b[2] + a[i][2]*b[2]
	return ab;

static func substract_matrix(a : Array, b : Array) -> Array:
	return [
		a[0] - b[0],
		a[1] - b[1],
		a[2] - b[2]
	]

static func differentiable_functions_values(x, y, abc) -> Array:
	# (A) = dz/da = 2*sum[(y_i-approximation_function(abc, x_i)) * dapproximation_function/da]
	# (B) = dz/db = 2*sum[first_multiplier * dapproximation_function/db]
	# (C) = dz/dc = 2*sum[first_multiplier * dapproximation_function/dc]
	var sqrtdiff_abc = [0, 0, 0]
	
	for i in x.size():
		var fm = first_multiplier(x[i], y[i], abc[0], abc[1], abc[2])
		sqrtdiff_abc[0] += fm*exp(abc[1]*x[i] + abc[2]*x[i]*x[i])
		sqrtdiff_abc[1] += fm*approximation_function(abc[0], abc[1], abc[2], x[i])*x[i]
		sqrtdiff_abc[2] += fm*approximation_function(abc[0], abc[1], abc[2], x[i])*x[i]*x[i]
		
	return sqrtdiff_abc;
# res = approximation_function(abc, x_i) - y_i
static func first_multiplier(x_i, y_i, a, b, c):
	var y_a = approximation_function(a, b, c, x_i)
	return y_a - y_i;

static func inverse_jacobian(x, y, abc) -> Array:
	# (dA/da	dA/db	dA/dc)
	# (dB/da	dB/db	dB/dc)
	# (dC/da	dC/db	dC/dc)
	var jacobian = Jacobian.calculate_jacobian(abc[0], abc[1], abc[2], x, y);
	return inverse_matrix(jacobian)

#			[a b c]				[A D G]
# A^(-1) =	[d e f] = 1/detA *	[B E H]
#			[g h i]				[C F I]
# A = -(ei-fh),	D = -(bi-ch),	G = (bf-ce),
# B = -(di-fg),	E = (ai-cg),	H = -(af-cd),
# C = (dh-eg),	F = -(ah-bg),	I = (ae-bd).
# detA = aA + bB + cC
static func inverse_matrix(matrix) -> Array:
	var a = - (matrix[1][1]*matrix[2][2] - matrix[1][2]*matrix[2][1])
	var b = - (matrix[1][0]*matrix[2][2] - matrix[1][2]*matrix[2][0])
	var c = (matrix[1][0]*matrix[2][1] - matrix[1][1]*matrix[2][0])
	var det = matrix[0][0]*a + matrix[0][1]*b + matrix[0][2]*c
	var d = - (matrix[0][1]*matrix[2][2] - matrix[0][2]*matrix[2][1])
	var e = (matrix[0][0]*matrix[2][2] - matrix[0][2]*matrix[2][0])
	var f = - (matrix[0][0]*matrix[2][1] - matrix[0][1]*matrix[2][0])
	var g = (matrix[0][1]*matrix[1][2] - matrix[0][2]*matrix[1][1])
	var h = - (matrix[0][0]*matrix[1][2] - matrix[0][2]*matrix[1][0])
	var i = (matrix[0][0]*matrix[1][1] - matrix[0][1]*matrix[1][0])
	
	return [
		[a/det, d/det, g/det],
		[b/det, e/det, h/det],
		[c/det, f/det, i/det]
	]
	
static func newton_iteration(x, y, initial_guess):
	var inverse_jacobian = inverse_jacobian(x, y, initial_guess)
	var differentiable_functions_values = differentiable_functions_values(x, y, initial_guess)
	var b = multiple_matrix(inverse_jacobian, differentiable_functions_values)
	return substract_matrix(initial_guess, b);
	
