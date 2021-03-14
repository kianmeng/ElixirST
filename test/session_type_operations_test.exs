defmodule ElixirSessionsOperations do
  use ExUnit.Case
  doctest ElixirSessions.Operations

  test "equal simple rec" do
    s1 = "rec X . (X)"
    s2 = "rec X . (X)"

    session1 = ST.string_to_st(s1)
    session2 = ST.string_to_st(s2)

    actual = ElixirSessions.Operations.equal(session1, session2)
    expected = true

    assert actual == expected
  end

  test "equal simple send/recv" do
    s1 = "?Hello() . !Ping(integer)"
    s2 = "?Hello() . !Ping(integer)"

    session1 = ST.string_to_st(s1)
    session2 = ST.string_to_st(s2)

    actual = ElixirSessions.Operations.equal(session1, session2)
    expected = true

    assert actual == expected
  end

  test "not equal simple rec" do
    s1 = "rec X . (Y)"
    s2 = "rec X . (X)"

    session1 = ST.string_to_st(s1)
    session2 = ST.string_to_st(s2)

    actual = ElixirSessions.Operations.equal(session1, session2)
    expected = false

    assert actual == expected
  end

  test "not equal simple send/recv" do
    s1 = "?Hello() . ?Ping(integer)"
    s2 = "?Hello() . !Ping(integer)"

    session1 = ST.string_to_st(s1)
    session2 = ST.string_to_st(s2)

    actual = ElixirSessions.Operations.equal(session1, session2)
    expected = false

    assert actual == expected
  end

  test "not equal simple send - different types" do
    s1 = "?Hello(integer)"
    s2 = "?Hello(atom)"

    session1 = ST.string_to_st(s1)
    session2 = ST.string_to_st(s2)

    actual = ElixirSessions.Operations.equal(session1, session2)
    expected = false

    assert actual == expected
  end

  test "equal branch" do
    s1 = "&{?Hello(integer), ?Hello2(integer, atom)}"
    s2 = "&{?Hello(integer), ?Hello2(integer, atom)}"

    session1 = ST.string_to_st(s1)
    session2 = ST.string_to_st(s2)

    actual = ElixirSessions.Operations.equal(session1, session2)
    expected = true

    assert actual == expected
  end

  test "not equal branch" do
    s1 = "&{?Hello(integer), ?Hello4(integer, atom)}"
    s2 = "&{?Hello(integer), ?Hello2(integer, atom)}"

    session1 = ST.string_to_st(s1)
    session2 = ST.string_to_st(s2)

    actual = ElixirSessions.Operations.equal(session1, session2)
    expected = false

    assert actual == expected
  end

  test "equal choice" do
    s1 = "+{!Hello(integer), !Hello2(integer, atom)}"
    s2 = "+{!Hello(integer), !Hello2(integer, atom)}"

    session1 = ST.string_to_st(s1)
    session2 = ST.string_to_st(s2)

    actual = ElixirSessions.Operations.equal(session1, session2)
    expected = true

    assert actual == expected
  end

  test "not equal choice" do
    s1 = "+{!Hello(integer), !Hello4(integer, atom)}"
    s2 = "+{!Hello(integer), !Hello2(integer, atom)}"

    session1 = ST.string_to_st(s1)
    session2 = ST.string_to_st(s2)

    actual = ElixirSessions.Operations.equal(session1, session2)
    expected = false

    assert actual == expected
  end

  test "equal complex" do
    s1 =
      "?M220(string).+{!Helo(string).?M250(string).rec X.(+{!MailFrom(string).?M250(string).rec Y.(+{!Data().?M354(string).!Content(string).?M250(string).X, !Quit().?M221(string), !RcptTo(string).?M250(string).Y}), !Quit().?M221(string)}), !Quit().?M221(string)}"

    s2 =
      "?M220(string).+{!Helo(string).?M250(string).rec X.(+{!MailFrom(string).?M250(string).rec Y.(+{!Data().?M354(string).!Content(string).?M250(string).X, !Quit().?M221(string), !RcptTo(string).?M250(string).Y}), !Quit().?M221(string)}), !Quit().?M221(string)}"

    session1 = ST.string_to_st(s1)
    session2 = ST.string_to_st(s2)

    actual = ElixirSessions.Operations.equal(session1, session2)
    expected = true

    assert actual == expected
  end

  test "not equal complex" do
    s1 =
      "?M220(string).+{!Helo(string).?M250(string).rec X.(+{!MailFrom(string).?M250(string).rec Y.(+{!Data().?M354(string).!Content(string).?M250(string).X, !Quit().?M221(string), !RcptTo(string).?M250(string).Y}), !Quit().?M221(string)}), !Quit().?M221(string)}"

    s2 =
      "?M220(string).+{!Helo(string).?M250(string).rec X.(+{!MailFrom(string).rec Y.(+{!Data().?M354(string).!Content(string).?M250(string).X, !Quit().?M221(string), !RcptTo(string).?M250(string).Y}), !Quit().?M221(string)}), !Quit().?M221(string)}"

    session1 = ST.string_to_st(s1)
    session2 = ST.string_to_st(s2)

    actual = ElixirSessions.Operations.equal(session1, session2)
    expected = false

    assert actual == expected
  end

  test "st_to_string_current complex" do
    s1 =
      "?M220(string).+{!Helo(string).?M250(string).rec X.(+{!MailFrom(string).?M250(string).rec Y.(+{!Data().?M354(string).!Content(string).?M250(string).X, !Quit().?M221(string), !RcptTo(string).?M250(string).Y}), !Quit().?M221(string)}), !Quit().?M221(string)}"

    session1 = ST.string_to_st(s1)

    actual = ElixirSessions.Operations.st_to_string_current(session1)
    expected = "?M220(string)"

    assert actual == expected
  end

  test "st_to_string complex" do
    s1 =
      "?M220(string).+{!Helo(string).?M250(string).rec X.(+{!MailFrom(string).?M250(string).rec Y.(+{!Data().?M354(string).!Content(string).?M250(string).X, !Quit().?M221(string), !RcptTo(string).?M250(string).Y}), !Quit().?M221(string)}), !Quit().?M221(string)}"

    session1 = ST.string_to_st(s1)

    actual = ElixirSessions.Operations.st_to_string(session1)
    expected = s1

    assert actual == expected
  end

  test "convert to structs semi complex" do
    input =
      {:recurse, :X,
       {:branch,
        [
          {:recv, :Ping, [], {:send, :Pong, [], {:call, :X}}},
          {:recv, :Quit, [], {:terminate}}
        ]}}

    expected = %ST.Recurse{
      body: %ST.Branch{
        branches: %{
          Ping: %ST.Recv{
            label: :Ping,
            next: %ST.Send{
              label: :Pong,
              next: %ST.Call_Recurse{label: :X},
              types: []
            },
            types: []
          },
          Quit: %ST.Recv{label: :Quit, next: %ST.Terminate{}, types: []}
        }
      },
      label: :X
    }

    result = ST.convert_to_structs(input)

    assert result == expected
  end

  test "Comparing session types simple" do
    s1 = "!Hello2(atom, list).!Hello(atom, list).?H11()"

    s2 = "!Hello2(atom, list).!Hello(atom, list)"

    case ST.session_remainder(ST.string_to_st(s1), ST.string_to_st(s2)) do
      {:ok, remaining_st} ->
        expected_remaining_st = ST.string_to_st("?H11()")
        assert expected_remaining_st == remaining_st

      {:error, _} ->
        assert false
    end
  end

  test "Comparing session types 1 choice" do
    s1 =
      "!Hello2(atom, list).+{!Hello(atom, list).?H11(), !Hello2(atom, list).?H11(), !Hello3(atom, list).?H11()}"

    s2 = "!Hello2(atom, list).!Hello(atom, list)"

    case ST.session_remainder(ST.string_to_st(s1), ST.string_to_st(s2)) do
      {:ok, remaining_st} ->
        expected_remaining_st = ST.string_to_st("?H11()")
        # throw("#{ST.st_to_string(remaining_st)}")
        assert expected_remaining_st == remaining_st

      {:error, _} ->
        assert false
    end

    s1 =
      "!Hello2(atom, list).+{!Hello(atom, list).?H11(), !Hello2(atom, list).?H11(), !Hello3(atom, list).?H11()}"

    s2 = "!Hello2(atom, list).+{!Hello(atom, list)}"

    case ST.session_remainder(ST.string_to_st(s1), ST.string_to_st(s2)) do
      {:ok, remaining_st} ->
        expected_remaining_st = ST.string_to_st("?H11()")
        # throw("#{ST.st_to_string(remaining_st)}")
        assert expected_remaining_st == remaining_st

      {:error, _} ->
        assert false
    end
  end

  test "Comparing session types 1 branch fail" do
    s1 =
      "!Hello2(atom, list).&{?Hello(atom, list).?H11(), ?Hello2(atom, list).?H11()}"

    s2 = "!Hello2(atom, list).?Hello(atom, list)"

    case ST.session_remainder(ST.string_to_st(s1), ST.string_to_st(s2)) do
      {:ok, remaining_st} ->
        assert false

      {:error, _} ->
        assert true

        x -> throw(x)
    end

    s1 =
      "!Hello2(atom, list).&{?Hello(atom, list).?H11(), ?Hello2(atom, list).?H11()}"

    s2 = "!Hello2(atom, list).&{?Hello(atom, list), ?Hello2(atom, list)}"

    case ST.session_remainder(ST.string_to_st(s1), ST.string_to_st(s2)) do
      {:ok, remaining_st} ->
        expected_remaining_st = ST.string_to_st("?H11()")
        # throw("#{ST.st_to_string(remaining_st)}")
        assert expected_remaining_st == remaining_st

      {:error, _} ->
        assert false
    end
  end
end
