public class Keys{
    Key up = new Key();
    Key down = new Key();
    Key right = new Key();
    Key left = new Key();
    int getPressedKeysCount(){
        return int(up.active) + int(down.active) + int(left.active) + int(right.active);
    }
}

public class Key{
    boolean active = false;
}