package org.rumal.security

import org.junit.Test
import org.hibernate.annotations.Check

/**
 * Created by IntelliJ IDEA.
 * User: darkchris
 * Date: 8/11/11
 * Time: 9:36 PM
 * To change this template use File | Settings | File Templates.
 */
class CheckPointTest extends GroovyTestCase {

    CheckPoint checkPoint

    public void tearDown() {
        CheckPoint.GLOBAL_APPLICATION_NAME = null
        checkPoint = null
    }

    @Test
    public void testNewCheckPoint() {
        // -
        try {
            checkPoint = CheckPoint.newCheckPoint('CHECKPOINT TEST', 'COMPONENT')
        } catch (e) {
            fail('Invalid check point creating')
        }

        // -
        try {
            checkPoint = CheckPoint.newCheckPoint('COMPONENT')
            fail('Invalid check point creating')
        } catch (e) {
        }

        // -
        CheckPoint.GLOBAL_APPLICATION_NAME = 'CHECKPOINT TEST'
        try {
            checkPoint = CheckPoint.newCheckPoint('COMPONENT')
        } catch (e) {
            fail('Invalid check point creating')
        }
    }

    @Test
    public void testCheck() {
        CheckPoint.GLOBAL_APPLICATION_NAME = 'CHECKPOINT TEST'
        checkPoint = CheckPoint.newCheckPoint('COMPONENT')

        try {
            checkPoint.check('ACTION', 3)
        } catch (CheckPointException e) {
            assert e.exceptionCode == CheckPoint.UNKNOWN_USER
        }

        try {
            checkPoint.check('COUNT', 2)
        } catch (CheckPointException e) {
            assert e.exceptionCode == CheckPoint.FORBIDDEN_ACTION
        }

    }

}
