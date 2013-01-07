class TestEntityManager extends haxe.unit.TestCase {
    var mgr : EntityManager;

    override public function setup() {
        mgr = new EntityManager();
    }

    public function testBasic() {
        var e : Entity = mgr.createEntityInstance();
    }
}
