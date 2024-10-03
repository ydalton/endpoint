static void test_bytes()
{
    string ret = Ep.show_length(100);
    assert_cmpstr(ret, CompareOperator.EQ, "100 B");
}

static void test_kilobytes1()
{
    string ret = Ep.show_length(1400);
    assert_cmpstr(ret, CompareOperator.EQ, "1.4 kB");
}

static void test_kilobytes2()
{
    string ret = Ep.show_length(14500);
    assert_cmpstr(ret, CompareOperator.EQ, "14.2 kB");
}

static void test_kilobytes3()
{
    string ret = Ep.show_length(146420);
    assert_cmpstr(ret, CompareOperator.EQ, "143.0 kB");
}

static void test_megabytes1()
{
    string ret = Ep.show_length(1048576);
    assert_cmpstr(ret, CompareOperator.EQ, "1.0 MB");
}

static void test_megabytes2()
{
    string ret = Ep.show_length(5000000);
    assert_cmpstr(ret, CompareOperator.EQ, "4.8 MB");
}

int main(string[] args)
{
    Test.init(ref args);

    Test.set_nonfatal_assertions();

    Test.add_func("/Utils/show_length/1", test_bytes);
    Test.add_func("/Utils/show_length/2", test_kilobytes1);
    Test.add_func("/Utils/show_length/3", test_kilobytes2);
    Test.add_func("/Utils/show_length/4", test_kilobytes3);
    Test.add_func("/Utils/show_length/5", test_megabytes1);
    Test.add_func("/Utils/show_length/6", test_megabytes2);

    return Test.run();
}
