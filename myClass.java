//a
public class myClass
{
	public static void main(String[] args)
	{
		final int x = 1;
		int i = 0;
		float a[5], b, c, d[7];
		double e, f[5];
		if(i<10)
		{
			System.out.println(i);
			// This is a comment.
			i++;
		} 
		else 
		{
			i--;
		}
		int s;
		s = this.square(5);
		System.out.println(s);

		System.out.println(this.rect(3,6));
	}

	int square(int n)
	{
		return n*n;
	}

	int rect(int a, float b)
	{
		return a*b;
	}
}
