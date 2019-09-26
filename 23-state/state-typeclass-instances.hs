module StateTypeclassInstances where

newtype State s a = State { runState :: s -> (a, s) }

instance Functor (State s) where
  -- fmap :: (a -> b) -> State s a -> State s b
  -- f :: a -> b
  -- g :: s -> (a, s)
  -- result :: s -> (b, s)
  fmap f (State g) = State $ \oldState ->
    let (val, newState) = g oldState
    in (f val, newState)

instance Applicative (State s) where
  -- pure :: a -> State s a
  pure a = State $ \s -> (a, s)

  -- <*> :: State s (a -> b) -> State s a -> State s b
  -- <*> :: (s -> (a -> b)) -> (s -> (a, s)) -> (s -> (b, s))
  -- f :: s -> ((a -> b), s)
  -- g :: s -> (a, s)
  (State f) <*> (State g) = State $ \s0 ->
    let (fn, s1) = f s0
        -- ((a -> b), s)
        (value, s2) = g s1
        -- (a, s)
    in  (fn value, s2)

instance Monad (State s) where
  -- return :: a -> State s a
  return = pure

  -- (>>=) :: State s a -> (a -> State s b) -> State s b
  -- (>>=) :: (s -> (a, s))               f
  --       -> (a -> (s -> (b, s)))        g
  --       -> (s -> (b, s))               result
  (State f) >>= g = State $ \s0 ->
    let (a, s1)   = f s0
        (State h) = g a
    in  h s1
