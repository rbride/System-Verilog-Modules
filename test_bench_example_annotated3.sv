//Monitor has a virtual interface handle with which it can monitor the events happening on the interface
//it sees new transactions & then captures info into a packet & sents it to scoreboard using mailbox
class monitor;
    virtual adder_if    m_adder_vif;
    virtual clk_if      m_clk_vif;
    mailbox scb_mbx; //mailbox connected to scoreboard

    task run();
        $display ("T=%0t [Monitor] starting ...", $time);
        //check Forever every clk edge to see if there is a valid transaction, if yes capture info
        //into a class object & send to scoreboard when the transaction is over
        forever begin
            packet m_pkt = new();
            @(posedge m_clk_vif.tb_clk);
                #1;
                m_pkt.a = m_adder_vif.a;     m_pkt.b = m_adder_vif.b;   m_pkt.rstn = m_adder_vif.rstn;
                m_pkt.sum = m_adder_vif.sum;    m_pkt.carry = m_adder_vif.carry;
                m_pkt.print("Monitor");     scb_mbx.put(m_pkt);
        end
    endtask
endclass


//ScoreBoard is responsible for checking data integrity, this design is simpleand addss input to give sum
// & carry, scoreboards helps to check if theoutput has changed for a given set of inputs based on expected logic
class scoreboard;
    mailbox scb_mbx; //the mailbox that receives data from the monitor
    
    task run();
        forever begin
            Packet item, ref_item;
            scb_mbx.get(item); //get the info sent by the monitor
            //Copy content from recieved packet into a new packet 
            ref_item = new();
            ref_item.copy(item);
            //Calculate if the stuff is correct
            //blah blah

            //If bad print its matches otherwise prints it does not
        end
    endtask
endclass

