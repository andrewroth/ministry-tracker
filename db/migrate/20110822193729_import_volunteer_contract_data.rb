class ImportVolunteerContractData < ActiveRecord::Migration
  
  NEW_CONTRACTS  = [
                    {:title => "Statement of Faith", :agreement_clause => "Without mental reservation, I hereby subscribe to the above statements and pledge myself to help fulfil the Great Commission in our generation, depending upon the Holy Spirit to guide and empower me.",
                     :clauses => [{:order => 1, :heading => "", :text => "The sole basis of our beliefs is the Bible, God's inerrant written Word, the 66 books of the Old and New Testaments.  We believe that it was uniquely, verbally and fully inspired by the Holy Spirit, and that it was written without factual error in the original manuscripts.  It is the supreme and final authority in all matters on which it speaks.", :checkbox => false},
                                  {:order => 2, :heading => "", :text => "We accept those large areas of doctrinal teaching on which, historically, there has been general agreement among all true Christians.  Because of the specialized calling of our movement, we desire to allow for freedom of conviction on other doctrinal matters, provided that any interpretation is based upon the Bible alone, and that no such interpretation shall become an issue which hinders the ministry to which God has called us. We explicitly affirm our belief in basic Bible teachings as follows:", :checkbox => false},
                                  {:order => 3, :heading => "", :text => "1.	There is one true God, eternally existing in three persons—the Father, Son and Holy Spirit—each of whom possesses equally all the attributes of Deity and the characteristics of personality.", :checkbox => true},
                                  {:order => 4, :heading => "", :text => "2.	Jesus Christ is God, the living Word, who became flesh through His miraculous conception by the Holy Spirit and His virgin birth.  Hence, He is perfect Deity and true humanity united in one person forever.", :checkbox => true},
                                  {:order => 5, :heading => "", :text => "3.	He lived a sinless life and voluntarily atoned for our sins by dying on the cross as our substitute, thus satisfying divine justice and accomplishing salvation for all who trust in Him alone.", :checkbox => true},
                                  {:order => 6, :heading => "", :text => "4.	He rose from the dead in the same body, though glorified, in which He had lived and died.", :checkbox => true},
                                  {:order => 7, :heading => "", :text => "5.	He ascended bodily into heaven and sat down at the right hand of God the Father, where He, the only mediator between God and mankind, continually makes intercession for His own.", :checkbox => true},
                                  {:order => 8, :heading => "", :text => "6.	We were originally created in the image of God.  We sinned by disobeying God; thus, we were alienated from our Creator.  That historic fall brought all mankind under divine condemnation.", :checkbox => true},
                                  {:order => 9, :heading => "", :text => "7.	Our nature is corrupted, and we are thus totally unable to please God.  Every person is in need of regeneration and renewal by the Holy Spirit.", :checkbox => true},
                                  {:order => 10, :heading => "", :text => "8.	Our salvation is wholly a work of God's free grace and is not the work, in whole or in part, of human works or goodness or religious ceremony.  God imputes His righteousness to those who put their faith in Christ alone for their salvation, and thereby justifies them in His sight.", :checkbox => true},
                                  {:order => 11, :heading => "", :text => "9.	It is the privilege of all who are born again of the Spirit to be assured of their salvation from the very moment in which they trust Christ as their Saviour.  This assurance is not based upon any kind of human merit, but is produced by the witness of the Holy Spirit, who confirms in the believer the testimony of God in His written Word.", :checkbox => true},
                                  {:order => 12, :heading => "", :text => "10.	The Holy Spirit has come into the world to reveal and glorify Christ and to apply the saving work of Christ to men and women.  He convicts and draws sinners to Christ, imparts new life to them, continually indwells them from the moment of spiritual birth and seals them until the day of redemption.  His fullness, power and control are appropriated in the believer's life by faith.", :checkbox => true},
                                  {:order => 13, :heading => "", :text => "11.	We, as believers, are called to live in the power of the indwelling Spirit so that we will not fulfill the lust of the flesh but will bear fruit to the glory of God.", :checkbox => true},
                                  {:order => 14, :heading => "", :text => "12.	Jesus Christ is the Head of the Church, His Body, which is composed of all men and women, living and dead, who have been joined to Him through saving faith.", :checkbox => true},
                                  {:order => 15, :heading => "", :text => "13.	God admonishes His people to assemble together regularly for worship, for participation in ordinances, for edification through the Scriptures and for mutual encouragement.", :checkbox => true},
                                  {:order => 16, :heading => "", :text => "14.	At physical death the believers enter immediately into eternal conscious fellowship with the Lord, and await the resurrection of their bodies to everlasting glory and blessing.", :checkbox => true},
                                  {:order => 17, :heading => "", :text => "15.	At physical death the unbelievers enter immediately into eternal conscious separation from the Lord and await the resurrection of their bodies to everlasting judgment and condemnation.", :checkbox => true},
                                  {:order => 18, :heading => "", :text => "16. 	Jesus Christ will come again to the earth—personally, visibly and bodily—to consummate history and the eternal plan of God.", :checkbox => true},
                                  {:order => 19, :heading => "", :text => "17.	The Lord Jesus Christ commanded all believers to proclaim the gospel throughout the world and to disciple men and women of every nation.  The fulfillment of that Great Commission requires that all worldly and personal ambition be subordinated to a total commitment to “Him who loved us and gave Himself for us.”", :checkbox => true}
                                 ]
                    },
                    
                    {:title => "Code of Conduct", :agreement_clause => "I am in agreement with the Personal Life and Conduct Policy and hereby commit myself to these disciplines, depending upon the Holy Spirit to guide and empower me.",
                     :clauses => [
                                  {:order => 1, :heading => "", :text => "Power to Change seeks to glorify God by making a maximum contribution toward helping to fulfil the Great Commission in Canada and around the world by developing movements of evangelism and discipleship. Therefore, Power to Change expects its employees and volunteers to live a life that is above reproach<sup>1</sup> and consistent with biblical standards. Therefore:", :checkbox => false},
                                  {:order => 2, :heading => "", :text => "I commit myself to present the gospel of Jesus Christ to all people and to minister to them through the direction and empowerment of the Holy Spirit. <br/><br/> <small><b>1)</b> I Tim. 3:1-7</small>", :checkbox => true},
                                  {:order => 3, :heading => "", :text => "I commit myself to obey Jesus’ commandment to His disciples<sup>2</sup> echoed by the Apostle Paul<sup>3</sup> to love and serve others. This includes respect for all people regardless of race, sex, status or stage of life. It precludes harming another person physically, emotionally or verbally, and instead means edifying others, showing compassion, demonstrating humility and patience, and considering the interests of others ahead of my own interests. <br/><br/> <small><b>2)</b> John 13:34,35   <b>3)</b> I Cor. 13; Phil.2:1-8; Col.3:1-17</small>", :checkbox => true},
                                  {:order => 4, :heading => "", :text => "I commit myself to refrain from practices which are biblically prohibited. Such practices include criminal violence<sup>4</sup>, drunkenness<sup>5</sup>, profane language<sup>6</sup>, abortion<sup>7</sup>, involvement in the occult<sup>8</sup>, premarital sex<sup>9</sup>, indulging in pornography<sup>10</sup>, living common law<sup>11</sup>, adultery<sup>12</sup>, homosexual behaviour<sup>13</sup> and dishonest practices such as cheating<sup>14</sup> and stealing<sup>15</sup>. <br/><br/> <small><b>4)</b> Ex 20:13; Rom 13:8-10   <b>5)</b> I Cor 6:10; Gal 5:21   <b>6)</b> Lev 24:10-16; Col 3:8   <b>7)</b> Ex 21:22-23; Ps 139:13-16   <b>8)</b> Dt 18:9-14; Gal 5:19-20   <b>9)</b> Ex 22:16; I Thess 4:1-8   <b>10)</b> Heb. 13:4   <b>11)</b> Ex 20:14,17; I Cor 6:9-11   <b>12)</b> Lev 18:22;20:13; I Cor 6:9-11; Rom 1:24-32   <b>13)</b> Lev 6:2-7; I Thess 4:6   <b>14)</b> Ex 20:15; Eph 4:28   <b>15)</b> Mt 23:25-28; Phil.2:14-16</small>", :checkbox => true},
                                  {:order => 5, :heading => "", :text => "I commit myself to maintain the highest ethical standards and honesty<sup>15</sup> in all ministry, business and personal dealings. I will avoid any real or apparent conflict of interest. <br/><br/> <small><b>15)</b> Mt 23:25-28; Phil.2:14-16</small>", :checkbox => true},
                                  {:order => 6, :heading => "", :text => "In light of my role as a spiritual leader, I commit myself to act as an example for the believers in speech, in life, in love, in faith and in purity.<sup>16</sup> Therefore, I will make lifestyle choices with a high level of consideration for those around me.<sup>17</sup> I will maintain discreet inoffensive behaviour in relationship to the opposite sex, and will abstain from the use of illegal drugs or the habitual use of tobacco or alcohol<sup>18</sup>. <br/><br/> <small><b>16)</b> I Tim. 4:12   <b>17)</b> Romans 14   <b>18)</b> I Cor 6:12-20</small>", :checkbox => true}
                                 ]
                    },
                    
                    {:title => "Confidential Information and Innovations", :agreement_clause => "I am in agreement with the terms listed above.",
                     :clauses => [
                                  {:order => 1, :heading => "", :text => "In this Agreement, “Confidential Information” means information disclosed to, used by, developed by, or made known to the Volunteer in the course of his/her engagement with PTC which is not generally known by persons outside of PTC’s Ministry; including, but not limited to, information (printed, electronic or otherwise) pertaining to those served by or its past, present, future and contemplated assets, operations, ministries, donors, donor contacts, and donor lists (except personal donors), personnel, finances, marketing methods or strategies, technologies, designs, routines, policies, and procedures.<br/><br/>By signing this Agreement, the Volunteer agrees to the following terms:", :checkbox => false},
                                  {:order => 2, :heading => "", :text => "1.	The Volunteer acknowledges that he/she will have access to and be trusted with Confidential Information in the course of his/her providing the Services to PTC. The Volunteer acknowledges and agrees that the right to maintain the absolute confidentiality of its Confidential Information is a proprietary and moral right, which PTC is obliged and entitled to protect.", :checkbox => true},
                                  {:order => 3, :heading => "", :text => "2.	The Volunteer covenants and agrees that he/she will not, except as required by law, either during the course of his/her engagement under this Agreement or at any time thereafter, directly or indirectly, by any means whatsoever, divulge, furnish, provide access to, or use for any other than the purposes of PTC, any of PTC’s Confidential Information; and that breach of this Agreement, pertaining to said Confidential Information, may result in immediate termination.", :checkbox => true},
                                  {:order => 4, :heading => "", :text => "3.	All works performed in the provision of the Services by the Volunteer at any time during the term of this Agreement, including but not limited to the development, modification or enhancement of ideas, opportunities, discoveries or improvement applicable to the ministry of PTC or to its fund raising activities or methods (the “Innovations”) shall be and remain the property of PTC, and the Volunteer shall treat the same as Confidential Information.", :checkbox => true},
                                  {:order => 5, :heading => "", :text => "4.	The Volunteer agrees to communicate at once to PTC all Innovations, which, during the term of this Agreement, the Volunteer may conceive, make or discover, or of which the Volunteer may become aware directly or indirectly, or which may be presented to the Volunteer in any manner, that relates in any way to the Ministry of PTC.", :checkbox => true},
                                  {:order => 6, :heading => "", :text => "5.	All such Innovations shall be the exclusive property of PTC, and the Volunteer hereby assigns and agrees to assign all rights and interest, including moral rights if any, to PTC, and to give all reasonable assistance as may be required by PTC to perfect its rights in the Innovations.", :checkbox => true}
                                 ]
                    }
                   ]
  
  def self.up
    NEW_CONTRACTS.each_with_index do |contract_hash, i|
      if Contract.all(:conditions => {:title => contract_hash[:title]}).blank? && Contract.all(:conditions => {:id => Contract::VOLUNTEER_CONTRACT_IDS[i]}).blank?
        
        new_contract = Contract.new(:title => contract_hash[:title], :agreement_clause => contract_hash[:agreement_clause])
        new_contract.id = Contract::VOLUNTEER_CONTRACT_IDS[i]
        new_contract.save!
        
        contract_hash[:clauses].each do |clause_hash|
          ContractClause.new(:contract_id => new_contract.id, :order => clause_hash[:order],
                             :heading => clause_hash[:heading], :text => clause_hash[:text], :checkbox => clause_hash[:checkbox]).save!
        end
      end
    end
  end

  def self.down
    NEW_CONTRACTS.each do |contract_hash|
      contract = Contract.all(:conditions => {:title => contract_hash[:title]})
      
      if contract.present?
        contract.first.clauses.destroy_all
        contract.first.signatures.destroy_all
        contract.first.destroy
      end
    end
  end
end

