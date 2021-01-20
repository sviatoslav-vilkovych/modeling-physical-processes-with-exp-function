class_name Math

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
	if (Singleton.actual_function == "cos(x)"):
		return cos(x)+0.0001 # 3*(x)*x+2*x-5
	elif (Singleton.actual_function == "sin(x)"):
		return sin(x)+0.0001
	elif (Singleton.actual_function == "3*x^3-2*x+1"):
		return 3*pow(x,3)-2*x+1;
	elif (Singleton.actual_function == "1/x^2"):
		return 1/(x*x);
	elif (Singleton.actual_function == "2*e^(x-3*x^2)"):
		return 2*exp(x-3*x*x)

static func mse(value, approximation_value):
	var mse = 0
	for i in range(approximation_value.size()):
		mse += pow(approximation_value[i] - value[i], 2)
	mse = sqrt(mse / approximation_value.size());
	return mse

static func polute_data_with_noise(data):
	var coef = 0.1
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var new_data = data
	var min_y = abs(new_data[1][0]);
	for i in new_data[1].size():
		if abs(new_data[1][i]) < abs(min_y):
			min_y = abs(data[1][i])
	
	for i in new_data[1].size():
		if (rng.randi_range(0,4) == 0):
			new_data[1][i] = new_data[1][i] + (min_y*coef if rng.randi_range(0,1) == 1 || new_data[1][i] - min_y*coef < 0 else -min_y*coef)
			
	return new_data;
